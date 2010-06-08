class EmailPreviewController < ApplicationController
  def show
    mail = EmailPreview.emails[params[:id]]
  end
end
