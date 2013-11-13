require 'active_attr'
class ClassifyConcern
  UPCOMING_CONCERNS = []

  def self.normalize_concern_name(name)
    name.to_s.classify
  end

  include ActiveAttr::Model
  attribute :curation_concern_type

  validates(
    :curation_concern_type,
    presence: true,
    inclusion: { in: lambda { |record| record.registered_curation_concern_types } }
  )

  def all_curation_concern_classes
    registered_curation_concern_types.sort.collect(&:constantize)
  end

  def possible_curation_concern_types
    registered_curation_concern_types.collect{|concern|
      [concern.constantize.human_readable_type, concern]
    }
  end

  def curation_concern_class
    if possible_curation_concern_types.detect{|name, class_name|
        class_name == curation_concern_type
      }
      curation_concern_type.constantize
    else
      raise RuntimeError, "Invalid :curation_concern_type"
    end
  end

  def upcoming_concerns
    UPCOMING_CONCERNS
  end

  require 'morphine'
  include Morphine
  register :registered_curation_concern_types do
    Curate.configuration.registered_curation_concern_types
  end
end
