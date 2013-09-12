module Curate
  # User - An Account that is assigned to a human; A User has a one to one relationship with a Person
  module User
    extend ActiveSupport::Concern
    included do
      include Curate::User::Base
      include Curate::User::WithAssociatedPerson
    end
  end
end
