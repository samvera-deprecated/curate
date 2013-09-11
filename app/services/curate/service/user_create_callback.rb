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
        @person = user.person
        Person.registered_attribute_names.each do |attr_name|
          @person.send("#{attr_name}=", user.send(attr_name)) if user.send("#{attr_name}_changed?")
        end
        @person.save!
        user.repository_id = @person.pid
        user.save
        @person
      end

    end
  end
end
