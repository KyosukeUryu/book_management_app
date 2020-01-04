Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'unread_books#tops'

  resources :unread_books do
    patch :reading, on: :member
    get :reading_books, on: :collection
    patch :return, on: :member
  end
end
