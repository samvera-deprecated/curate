module Curate
  class UserWrapper < SimpleDelegator
    attr_reader :user
    def initialize(user)
      @user = user
      super(user)
    end

    def save
      create_person_with_profile
    end

    def update_with_password(params)
      super
      update_person
    end
  end
end