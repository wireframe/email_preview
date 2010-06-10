class EmailPreviewController < ApplicationController
  unloadable
  before_filter :enforce_allowed_environments
  before_filter :build_email, :only => [:show, :deliver]
  layout nil

  def deliver
    @mail.to params[:to]
    @mail.deliver
    redirect_to email_preview_path(params[:id])
  end
  private
  def enforce_allowed_environments
    raise "'#{Rails.env}' is not in the supported list of environments from EmailPreview.allowed_environments: #{EmailPreview.allowed_environments.inspect}" unless EmailPreview.allowed_environments.include?(Rails.env)
  end
  def build_email
    @mail = EmailPreview.preview params[:id]
  end
end
