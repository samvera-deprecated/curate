module Curate::WithAssociatedPerson
  extend ActiveSupport::Concern

  included do
    # Every User has an associated Person record in Fedora
    after_commit :update_person, on: [:create, :update]
    after_create :create_person_with_profile
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

  def create_person_with_profile
    person.create_profile(self)
  end
  private :create_person_with_profile

  def person
    @person ||= if self.repository_id
      Person.find(self.repository_id)
    else
      create_person
    end
  end

  # Make a new person object and populate it.
  # Must be careful since when we update ourselves with a link to the new
  # person object, we will trigger a callback to save the person
  # object (again).
  def create_person
    person = Person.new
    yield if block_given?
    person.alternate_email = email
    person.apply_depositor_metadata(self.user_key)
    person.read_groups = [Sufia::Models::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC]
    person.save!
    self.repository_id = person.pid
    self.save
    person
  end
  private :create_person

  def update_person
    person.save
  end
  protected :update_person

  def display_name
    @display_name ||= self.attributes['display_name'] || person.name
  end

  def display_name=(display_name)
    write_attribute(:display_name, display_name)
    person.name= display_name
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
