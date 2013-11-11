class Account
  # The nastiness that allows us to treat the Account as a User
  include Curate::DeviseUserShim
  self.wrapped_class = User

  def inspect
    "#<#{self.class} user.id: #{user.id}, user.repository_id: #{user.repository_id}, attributes: #{attributes.inspect}>"
  end

  def is_a?(comparison)
    super || user.is_a?(comparison)
  end

  include ActiveAttr::Model

  def initialize(user, attributes = user.attributes)
    @user = user
    self.attributes = attributes
  end

  attr_reader :user

  delegate :person, to: :user

  def profile
    @profile ||= person.profile || person.build_profile(title: profile_title)
  end

  class_attribute :person_attribute_names
  self.person_attribute_names = []
  class_attribute :user_attribute_names
  self.user_attribute_names = User.attribute_names_for_account

  def self.apply_person_attributes
    Person.editable_attributes.each do |att|
      self.person_attribute_names += [att.name.to_s]
      attribute(att.name)
      att.with_validation_options do |name, opts|
        validates(name, opts)
      end
    end
  end

  def self.apply_user_attributes
    user_attribute_names.each do |attribute_name|
      attribute(attribute_name)
    end
  end

  apply_person_attributes
  apply_user_attributes

  def create
    if create_user &&
        create_person &&
        create_profile
      true
    else
      collect_errors
    end
  end
  # Create is indicative of what is happening, however Devise calls #save
  alias save create

  def collect_errors
    user.errors.each do |key, value|
      errors.add(key, value)
    end
    person.errors.each do |key, value|
      errors.add(key, value)
    end
    profile.errors.each do |key, value|
      errors.add(key, value)
    end
  end
  protected :collect_errors

  def update_with_password(initial_params, *options)
    params = normalize_update_params(initial_params)
    extract_user_and_person_attributes_for_update(params)
    if update_user(*options) &&
        update_person &&
        update_profile
      true
    else
      collect_errors
      false
    end
  end

  delegate :persisted?, :to_param, :to_key, :new_record?, to: :user

  def method_missing(method_name, *args, &block)
    begin
      super
    rescue NoMethodError
      user.send(method_name, *args, &block)
    end
  end

  def respond_to_missing?(*args)
    super || user.respond_to?(*args)
  end

  private

  def normalize_update_params(params)
    options = params.dup.with_indifferent_access
    ['password', 'password_confirmation'].each do |key|
      if options.has_key?(key) && options[key].empty?
        options.delete(key)
      end
    end
    options
  end

  def create_profile
    apply_deposit_authorization(profile)
    profile.save && connect_person_to_profile
  end

  def update_profile
    create_profile unless profile.persisted?
    sync_profile_title_to_name(person_attributes)
  end

  def create_user
    user.attributes = user_attributes
    user.save
  end

  def update_user(*options)
    user.update_with_password(user_attributes, *options)
  end

  def create_person
    person.attributes = person_attributes
    apply_deposit_authorization(person)
    person.save && connect_user_to_person
  end

  def update_person
    if person.persisted?
      person.update(person_attributes)
    else
      create_person
    end
  end

  def apply_deposit_authorization(target)
    target.apply_depositor_metadata(user.user_key)
    target.read_groups = [Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC]
    target
  end

  def connect_user_to_person
    user.update_column(:repository_id, person.pid)
  end

  def connect_person_to_profile
    person.profile = profile
    person.save
  end

  def user_attributes
    unless @user_attributes
      extract_user_and_person_attributes_for_update
    end
    @user_attributes
  end

  def person_attributes
    unless @person_attributes
      extract_user_and_person_attributes_for_update
    end
    @person_attributes
  end

  def extract_user_and_person_attributes_for_update(from_attributes = attributes)
    person.add_profile_image(from_attributes["files"]) if from_attributes.has_key?("files")
    @user_attributes = {}.with_indifferent_access
    @person_attributes = {}.with_indifferent_access
    from_attributes.each_pair do |key, value|
      if !value.nil?
        if person_attribute_names.include?(key.to_s)
          @person_attributes[key] = value
        end
        if user_attribute_names.include?(key.to_s)
          @user_attributes[key] = value
        end
      end
    end
  end

  def profile_title
    person.name.nil? ? 'Profile' : person.name
  end

  def sync_profile_title_to_name(update_attributes)
    return true unless update_attributes[:name]
    profile.update(title: profile_title)
  end

end
