class EmailPreviewController < ApplicationController
  unloadable
  layout false

  before_filter :enforce_allowed_environments
  around_filter :set_delivery_method, :only => :deliver
  before_filter :build_email, :only => [:show, :deliver, :details, :preview]

  def deliver
    @mail.to params[:to]
    @mail.respond_to?(:deliver_now) ? @mail.deliver_now : @mail.deliver
    @mail.deliver
    redirect_to details_email_preview_path(params[:id])
  end
  def preview
    @part = if request.format == 'html'
      @parts.detect {|p| p.content_type && p.content_type.include?('text/html') }
    else
      @parts.detect {|p| p.content_type && p.content_type.include?('text/plain') }
    end
    @part ||= @parts.first
    render :text => @part.body.to_s
  end
  private
  def enforce_allowed_environments
    raise "'#{Rails.env}' is not in the supported list of environments from EmailPreview.allowed_environments: #{EmailPreview.allowed_environments.inspect}" unless EmailPreview.allowed_environments.include?(Rails.env)
  end
  def build_email
    @mail = EmailPreview.preview params[:id]
    @parts = @mail.multipart? ? @mail.parts : [@mail]
  end
  def set_delivery_method
    previous_delivery_method = ActionMailer::Base.delivery_method
    ActionMailer::Base.delivery_method = EmailPreview.delivery_method if EmailPreview.delivery_method
    yield
  ensure
    ActionMailer::Base.delivery_method = previous_delivery_method
  end
end
