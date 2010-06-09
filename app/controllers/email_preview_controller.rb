class EmailPreviewController < ApplicationController
  unloadable
  def show
    @mail = EmailPreview.emails[params[:id].to_sym]
  end
end
