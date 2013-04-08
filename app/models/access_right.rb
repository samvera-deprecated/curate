require 'method_decorators/precondition'

class AccessRight
  PERMISSION_TEXT_VALUE_PUBLIC = 'public'.freeze
  PERMISSION_TEXT_VALUE_AUTHENTICATED = 'registered'.freeze
  VISIBILITY_TEXT_VALUE_PUBLIC = 'open'.freeze
  VISIBILITY_TEXT_VALUE_AUTHENTICATED = 'psu'.freeze
  VISIBILITY_TEXT_VALUE_PRIVATE = 'restricted'.freeze

  extend MethodDecorators
  +MethodDecorators::Precondition.new { |permissionable|
    permissionable.respond_to?(:visibility) &&
    permissionable.respond_to?(:persisted?) &&
    permissionable.respond_to?(:permissions) &&
    permissionable.permissions.respond_to?(:map)
  }
  def initialize(permissionable)
    @permissionable = permissionable
  end

  extend Forwardable
  def_delegators :permissionable, :persisted?, :permissions, :visibility
  protected :persisted?, :permissions, :visibility

  attr_reader :permissionable

  def open_access?
    return true if has_visibility_text_for?(VISIBILITY_TEXT_VALUE_PUBLIC)
    if persisted?
      has_permission_text_for?(PERMISSION_TEXT_VALUE_PUBLIC)
    else
      visibility.to_s == ''
    end
  end

  def authenticated_only?
    return false if open_access?
    has_permission_text_for?(PERMISSION_TEXT_VALUE_AUTHENTICATED) ||
      has_visibility_text_for?(VISIBILITY_TEXT_VALUE_AUTHENTICATED)
  end

  def private?
    !open_access? && !authenticated_only?
  end

  private
  def has_visibility_text_for?(text)
    visibility == text
  end
  def has_permission_text_for?(text)
    !!permissions.detect { |perm| perm[:name] == text }
  end
end
