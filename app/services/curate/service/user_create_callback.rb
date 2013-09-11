module Curate
  module Service
    class UserCreateCallback
      def self.call(user)
        new(user).call
      end
      attr_reader :user
      def initialize(user)
        @user = user
      end

      def call
        create_person
        create_profile
      end

      protected

      def create_profile
        @profile = person.create_profile(user)
      end

      def profile
        @profile ||= create_profile
      end

      def person
        @person ||= create_person
      end

      def create_person
        @person = Person.new
        @person.alternate_email = user.email
        @person.save!
        user.repository_id = @person.pid
        user.save
        @person
      end

    end
  end
end
