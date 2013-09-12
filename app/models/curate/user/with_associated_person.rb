module Curate
  module User
    module WithAssociatedPerson
      extend ActiveSupport::Concern

      included do
        # Every User has an associated Person record in Fedora
        after_commit :user_create_callback, on: [:create]
        after_commit :user_update_callback, on: [:update]

        # TODO - cache these on the user and synchronize with the
        # repository
        delegate :date_of_birth, :gender, :title,
          :campus_phone_number, :alternate_phone_number,
          :personal_webpage, :blog, :preferred_email,
          :profile,
          to: :person
        delegate :date_of_birth=, :gender=, :title=,
          :campus_phone_number=, :alternate_phone_number=,
          :personal_webpage=, :blog=, :preferred_email=,
          to: :person
      end

      def user_create_callback
        Curate.configuration.user_create_callback.call(self)
      end
      protected :user_create_callback

      def user_update_callback
        Curate.configuration.user_update_callback.call(self)
      end
      protected :user_update_callback

      def person
        @person ||= if self.repository_id
          Person.find(self.repository_id)
        else
          Person.new
        end
      end

      def display_name
        @display_name ||= self.attributes['display_name'] || person.name
      end

      def display_name=(display_name)
        write_attribute(:display_name, display_name)
        person.name = display_name
      end

      alias_method :name, :display_name
      alias_method :name=, :display_name=

      def alternate_email
        if person.blank? || person.alternate_email.blank?
          return email
        end
        person.alternate_email
      end

      def alternate_email=(alternate_email)
        person.alternate_email = alternate_email
      end

    end
  end
end
