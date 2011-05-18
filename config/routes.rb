Rails.application.routes.draw do
  resources :email_preview, :controller => 'email_preview', :only => [:index, :show] do
    collection do
      get :navigation
    end
    member do
      post :deliver
    end
  end
end
