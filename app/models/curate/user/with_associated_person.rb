module Curate
  module User
    module WithAssociatedPerson
      extend ActiveSupport::Concern

      included do
        after_commit :user_create_callback, on: [:create]
        after_commit :user_update_callback, on: [:update]

        delegate :profile, to: :person

        alias_attribute :name, :display_name

        Person.registered_attribute_names.each do |method_name|
          unless attribute_method?(method_name)
            define_method(method_name) do
              @person_attributes ||= {}
              @person_attributes.fetch(method_name, person.send(method_name))
            end
            define_method("#{method_name}=") do |value|
              @person_attributes ||= {}
              @person_attributes[method_name] = value
            end
            define_method("#{method_name}_changed?") do
              @person_attributes ||= {}
              !!@person_attributes.fetch(method_name, false)
            end
          end
        end
      end

      def reload
        @person_attributes = {}
        super
      end

      def preferred_email; email; end
      def preferred_email=(value); self.email = value; end

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
    end
  end
end
