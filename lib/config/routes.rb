Rails.application.routes.draw do |map|
  resources :email_preview, :controller => 'email_preview', :only => [:index, :show]
end
