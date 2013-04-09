require 'active_attr'
class ClassifyConcern
  # @TODO - This should be part of the application configuration
  # or detected on load
  VALID_CURATION_CONCERNS = {
    'Mock Curation Concern' => 'MockCurationConcern'
  }
  include ActiveAttr::Model
  attribute :curation_concern_type

  validates(
    :curation_concern_type,
    presence: true,
    inclusion: { in: lambda { |record| VALID_CURATION_CONCERNS.values } }
  )

  def possible_curation_concern_types
    VALID_CURATION_CONCERNS
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
end
