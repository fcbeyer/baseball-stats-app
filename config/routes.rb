Rails.application.routes.draw do
  resources :players do
    get 'leaderboard', on: :collection
    resources :battings
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
