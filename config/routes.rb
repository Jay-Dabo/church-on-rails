Rails.application.routes.draw do
  root to: 'home#index'

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  authenticate do
    scope module: 'people' do
      resources :families, concerns: :paginatable do
        get :confirm_destroy, on: :member
        resources :family_memberships, path: 'memberships'
      end
      resources :teams, concerns: :paginatable do
        get :confirm_destroy, on: :member
        resources :team_memberships, path: 'memberships'
        resources :events, controller: '/events/events'
      end
      resources :people, concerns: :paginatable do
        get :confirm_destroy, on: :member
        resource :user
        resource :teams, controller: :person_teams
        resource :families, controller: :person_families
        resources :person_processes, path: 'processes'
      end
    end

    scope module: 'events' do
      resources :events, concerns: :paginatable do
        get :confirm_destroy, on: :member
      end
    end

    scope module: 'processes' do
      resources :church_processes, concerns: :paginatable, path: 'processes' do
        get :confirm_destroy, on: :member
        resources :person_processes, path: 'people'
      end
    end

    namespace :account do
      get '/' => 'people#show'
      as :user do
        get 'resend_confirmation' => 'confirmations#resend'
      end
      resource :person
    end
  end

  devise_for :users,
             sign_out_via: :get,
             controllers: {
               confirmations: 'account/confirmations',
               registrations: 'account/registrations'
             },
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             }

  resources :users

end
