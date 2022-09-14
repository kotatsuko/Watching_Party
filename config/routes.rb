Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  devise_for :end_users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  devise_scope :end_user do
    post 'end_users/guest_sign_in', to: 'public/sessions#guest_sign_in'
    get '/end_users', to: 'public/registrations#new'
  end

  namespace :admin do
    get '' => 'homes#top'

    resources :posts, only: [:index, :show, :destroy]

    get "groups/popular" => "groups#popular_index"
    get "groups/start" => "groups#start_index"
    get "groups/long" => "groups#long_index"
    get "groups/short" => "groups#short_index"
    get "groups/closed" => "groups#closed_index"
    resources :groups, except: [:edit, :update] do
      delete "group_comments/:id" => "groups#comment_destroy", as: "admin_group_comment_destroy"
    end

    resources :end_users, only: [:index, :show, :edit, :update]

  end

  scope module: :public do
    root 'homes#top'
    get 'about' => 'homes#about'

    resources :end_users, only: [:show, :edit, :update] do
      get "my_favorites" => "end_users#my_favorites"
      get "my_posts" => "end_users#my_posts"
      get "my_groups" => "end_users#my_groups"
      resource :relationships, only: [:create, :destroy]
      get "confirm" => "end_users#confirm"
      patch "deleted" => "end_users#deleted"
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end

    get "posts/popular" => "posts#popular_index"
    resources :posts do
      resources :post_comments, only: [:create, :destroy]
      resource :post_favorites, only: [:create, :destroy]
    end

    get "groups/popular" => "groups#popular_index"
    get "groups/start" => "groups#start_index"
    get "groups/long" => "groups#long_index"
    get "groups/short" => "groups#short_index"
    get "groups/closed" => "groups#closed_index"
    resources :groups do
      get "join" => "groups#join"
      delete "leave" => "groups#leave"
      resources :group_comments, only: [:create, :destroy]
    end

    get "tag_search/:id" => "searches#tag_search", as: "tag_search"
    get "search" => "searches#search"

  end



  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
