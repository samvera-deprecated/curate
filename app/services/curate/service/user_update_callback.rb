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
        @person = user.person
        Person.registered_attribute_names.each do |attr_name|
          @person.send("#{attr_name}=", user.send(attr_name)) if user.send("#{attr_name}_changed?")
        end
        @person.save
        @person
      end
    end
  end
end
