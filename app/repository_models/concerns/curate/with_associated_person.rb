module Curate::WithAssociatedPerson
  extend ActiveSupport::Concern

    included do
      after_create :find_or_create_person
      after_update :update_person
      delegate :date_of_birth, :gender, :title,
               :campus_phone_number, :alternate_phone_number,
               :personal_webpage, :blog,
               to: :person
      delegate :date_of_birth=, :gender=, :title=,
               :campus_phone_number=, :alternate_phone_number=,
               :personal_webpage=, :blog=,
               to: :person
    end

    def person
      @person ||= Person.find(self.repository_id)
    rescue ArgumentError
      nil 
    end

    def find_or_create_person
      @person = Person.find_or_create_by_user(self)
    end

    def display_name
      @display_name ||= self.attributes['display_name'] || person.name
    end

    def display_name=(display_name)
      write_attribute(:display_name, display_name)
      person.name= display_name
    end

    alias_method :name, :display_name
    alias_method :name=, :display_name=

    def preferred_email
      person.preferred_email
    end

    def preferred_email=(preferred_email)
      person.preferred_email= preferred_email
    end

    def alternate_email
      if person.blank? || person.alternate_email.blank?
        return email
      end
      person.alternate_email
    end

    def alternate_email=(alternate_email)
      person.alternate_email = alternate_email
    end

    def update_person
      person.save
    end
    protected :update_person

end

