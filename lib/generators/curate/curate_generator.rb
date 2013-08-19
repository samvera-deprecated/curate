# -*- encoding : utf-8 -*-
require 'rails/generators'

class CurateGenerator < Rails::Generators::Base
  desc """
This generator makes the following changes to your application:
 1. Adds the curate routes
       """ 

  # The engine routes have to come after the devise routes so that /users/sign_in will work
  def inject_routes
    routing_code = "\n  mount Curate::Engine => '/'\n"
    sentinel = /devise_for :users/
    inject_into_file 'config/routes.rb', routing_code, { :after => sentinel, :verbose => false }
  end
end
