Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  devise_for :end_users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  namespace :admin do
    get '' => 'homes#top'

    resources :post, only: [:index, :show, :destroy]

    get "groups/popular" => "groups#popular_index"
    get "groups/start" => "groups#start_index"
    get "groups/long" => "groups#long_index"
    get "groups/short" => "groups#short_index"
    resources :group, except: [:edit, :update]

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
    resources :groups do
      resources :group_comments, only: [:create, :destroy]
    end

    get "search" => "searches#search"
    get "search" => "searches#tag_search"

  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
