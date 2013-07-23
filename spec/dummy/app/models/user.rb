require Sufia::Models::Engine.root.join('lib/sufia/models/user')
class User < ActiveRecord::Base
  # Connects this user object to Sufia behaviors.
  include Sufia::User
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  def agree_to_terms_of_service!
    update_column(:agreed_to_terms_of_service, true)
  end
end
