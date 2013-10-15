module Curate
  # User - An Account that is assigned to a human; A User has a one to one relationship with a Person
  module UserBehavior
    extend ActiveSupport::Concern
    included do
      include Curate::UserBehavior::Base
      include Curate::UserBehavior::WithAssociatedPerson
      include Curate::UserBehavior::Delegates
    end

    module ClassMethods
      def attribute_names_for_account
        ['name', 'password', 'password_confirmation', 'current_password'] + attribute_names
      end
    end
  end
end
