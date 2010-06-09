class EmailPreviewController < ApplicationController
  unloadable
  def show
    mail = EmailPreview.emails[params[:id]]
  end
end
