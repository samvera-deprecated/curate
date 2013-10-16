module Curate
  module UserBehavior
    module WithAssociatedPerson
      extend ActiveSupport::Concern

      included do
        person_attributes_not_already_on_base =
          Person.registered_attribute_names - attribute_names_for_account

        person_attributes_not_already_on_base.each do |attribute_name|
          delegate attribute_name, to: :person
          delegate :profile, to: :person
        end
      end

      def reload
        @person = nil
        super
      end

      def person
        @person ||= if self.repository_id
                      Person.find(self.repository_id)
                    else
                      Person.new
                    end
      end

    end
  end
end
