module Curate
  # User - An Account that is assigned to a human; A User has a one to one relationship with a Person
  module User
    extend ActiveSupport::Concern
    included do
      include Curate::User::Base
      include Curate::User::WithAssociatedPerson
    end

    module ClassMethods
      def attribute_names_for_account
        ['name', 'password', 'password_confirmation', 'current_password'] + attribute_names
      end
    end
  end
end
