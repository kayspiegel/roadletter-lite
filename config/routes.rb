Rails.application.routes.draw do
  # Signed-out admin pages. There is no sign-up: the one admin is created by db:seed.
  resource :session, only: %i[ new create destroy ]
  resources :passwords, param: :token, only: %i[ new create edit update ]

  namespace :admin do
    root "dashboard#show"
    resource :locale, only: :update
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # The public home page arrives with the archive. Until then, / leads to the admin.
  root to: redirect("/admin")
end
