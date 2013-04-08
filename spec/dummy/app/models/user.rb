class User < ActiveRecord::Base
  # Connects this user object to Sufia behaviors.
  include Sufia::User
end
