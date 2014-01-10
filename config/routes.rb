Rails.application.routes.prepend do
  resources :email_preview, :controller => 'email_preview', :only => [:index, :show] do
    collection do
      get :navigation
    end
    member do
      post :deliver
      get :details
      get :preview
    end
  end
end
