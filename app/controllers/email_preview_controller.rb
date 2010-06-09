class EmailPreviewController < ApplicationController
  unloadable
  before_filter :enforce_allowed_environments

  def show
    @mail = EmailPreview.preview params[:id]
  end
  private
  def enforce_allowed_environments
    raise "'#{Rails.env}' is not in the supported list of environments from EmailPreview.allowed_environments: #{EmailPreview.allowed_environments.inspect}" unless EmailPreview.allowed_environments.include?(Rails.env)
  end
end
