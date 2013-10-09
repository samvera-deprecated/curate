class InlineReflection < ActiveFedora::Reflection::ClassMethods::AssociationReflection
  attr_reader :options

  def initialize opts = {}
    @options = opts
  end

  def collection?
    true
  end

end
