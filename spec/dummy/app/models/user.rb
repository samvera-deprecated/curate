class User < ActiveRecord::Base
  # Connects this user object to Sufia behaviors.
  include Sufia::User
  devise :recoverable, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  def password; 'password'; end
end
