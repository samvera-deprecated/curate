module Curate
  module Service
    class UserUpdateCallback
      def self.call(user)
        new(user).call
      end
      attr_reader :user
      def initialize(user)
        @user = user
      end

      def call
        update_person
      end

      protected

      def update_person
        user.person.update
      end
    end
  end
end
