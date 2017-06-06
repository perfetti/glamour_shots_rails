Rails.application.routes.draw do
  root to: 'glamour#index'
  get '/check_name' => 'glamour#check_name', as: :check_name
end
