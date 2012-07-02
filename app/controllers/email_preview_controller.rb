class EmailPreviewController < ApplicationController
  unloadable
  layout false

  before_filter :enforce_allowed_environments
  before_filter :build_email, :only => [:show, :deliver, :details, :preview]

  def deliver
    @mail.to params[:to]
    
    previous_delivery_method = ActionMailer::Base.delivery_method
    begin
      ActionMailer::Base.delivery_method = EmailPreview.delivery_method if EmailPreview.delivery_method
      @mail.deliver
    ensure
      ActionMailer::Base.delivery_method = previous_delivery_method
    end
    redirect_to details_email_preview_path(params[:id])
  end
  def preview
    content_type = (request.format == 'html' ? 'text/html' : 'text/plain')
    @part = @parts.detect { |p| p.content_type && p.content_type.include?(content_type) } || @parts.first
    @part ||= @parts.first
    render :text => @part.body.to_s
  end
  private
  def enforce_allowed_environments
    raise "'#{Rails.env}' is not in the supported list of environments from EmailPreview.allowed_environments: #{EmailPreview.allowed_environments.inspect}" unless EmailPreview.allowed_environments.include?(Rails.env)
  end
  def build_email
    @mail = EmailPreview.preview params[:id]
    @parts = @mail.multipart? ? detect_content_parts(@mail.parts) : [@mail]
  end

  def detect_content_parts(parts)
    alternative = parts.detect { |p| p.content_type && p.content_type.include?('multipart/alternative') }
    alternative ? alternative.parts : parts
  end
end
