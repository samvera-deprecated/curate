class User < ActiveRecord::Base
  # Connects this user object to Sufia behaviors.
  include Sufia::User
  devise :recoverable, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  def password; 'password'; end

  def agree_to_terms_of_service!
    update_column(:agreed_to_terms_of_service, true)
  end

end
