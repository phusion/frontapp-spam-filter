Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'page#index'
  namespace 'hooks' do
    %w(inbound move).each do |action|
      post "/#{action}/:token", action: action
    end
  end

end
