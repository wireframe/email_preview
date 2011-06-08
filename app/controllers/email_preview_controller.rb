class EmailPreviewController < ApplicationController
  unloadable
  before_filter :enforce_allowed_environments
  before_filter :build_email, :only => [:show, :deliver, :details, :preview]
  layout nil

  def deliver
    @mail.to params[:to]
    @mail.deliver
    redirect_to email_preview_path(params[:id])
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
end
