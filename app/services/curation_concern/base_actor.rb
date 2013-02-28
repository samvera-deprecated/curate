module CurationConcern
  # The CurationConcern base actor should respond to three primary actions:
  # * #create
  # * #update
  # * #delete
  class BaseActor
    attr_reader :curation_concern, :user, :attributes
    def initialize(curation_concern, user, attributes)
      @curation_concern = curation_concern
      @user = user
      @attributes = attributes
    end

    def create
      curation_concern.apply_depositor_metadata(user.user_key)
      curation_concern.creator = user.name
      curation_concern.date_uploaded = Date.today
      save
    end

    def update
      save
    end

    def save
      curation_concern.attributes = attributes
      curation_concern.date_modified = Date.today
      curation_concern.set_visibility(visibility)
      curation_concern.save!
    end
    protected :save

    def visibility
      return @visibility if defined?(@visibility)
      @visibility = attributes.delete(:visibility)
    end
    protected :visibility

    def visibility_may_have_changed?
      defined?(@visibility)
    end
    protected :visibility_may_have_changed?
  end
end
