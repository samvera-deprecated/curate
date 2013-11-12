module Curate
  # User - An Account that is assigned to a human; A User has a one to one relationship with a Person
  module UserBehavior
    extend ActiveSupport::Concern

    include Curate::UserBehavior::Base
    include Curate::UserBehavior::WithAssociatedPerson
    include Curate::UserBehavior::Delegates

  end
end
