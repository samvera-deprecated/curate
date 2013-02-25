class AddUserAgreedToTermsOfService < ActiveRecord::Migration
  def change
    add_column :users, :agreed_to_terms_of_service, :boolean, default: false
  end
end
