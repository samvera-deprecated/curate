module Curate
  module UserBehavior
    module WithAssociatedPerson
      extend ActiveSupport::Concern

      included do
        person_attributes_not_already_on_base =
          Person.registered_attribute_names - attribute_names_for_account

        person_attributes_not_already_on_base.each do |attribute_name|
          delegate attribute_name, to: :person
        end
        delegate :profile, to: :person, allow_nil: true
      end

      def reload
        @person = nil
        super
      end

      def person= p
        @person = p
        self.repository_id = p.pid
      end

      def person
        @person ||= if self.repository_id
          Person.find(self.repository_id)
        else
          Person.new(name: name)
        end
      end

      module ClassMethods
        def attribute_names_for_account
          ['name', 'password', 'password_confirmation', 'current_password'] + attribute_names
        end
      end

    end
  end
end
