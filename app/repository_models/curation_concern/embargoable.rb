require File.expand_path('../../../validators/future_date_validator', __FILE__)
module CurationConcern
  module Embargoable
    module VisibilityOverride
      def set_visibility(value)
        if value == AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO
          super(AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC)
        else
          self.embargo_release_date = nil
          super(value)
        end
      end
    end
    include VisibilityOverride
    extend ActiveSupport::Concern

    included do
      validates :embargo_release_date, future_date: true
      before_save :write_embargo_release_date, prepend: true
    end


    def write_embargo_release_date
      if defined?(@embargo_release_date)
        embargoable_persistence_container.embargo_release_date = @embargo_release_date
      end
      true
    end
    protected :write_embargo_release_date

    def embargo_release_date=(value)
      @embargo_release_date = begin
        value.present? ? value.to_date : nil
      rescue NoMethodError
        value
      end
    end

    def embargo_release_date
      @embargo_release_date || embargoable_persistence_container.embargo_release_date
    end

    if ! included_modules.include?('Morphine')
      require 'morphine'
      include Morphine
    end
    register :embargoable_persistence_container do
      if ! self.class.included_modules.include?('Sufia::GenericFile::Permissions')
        self.class.send(:include, Sufia::GenericFile::Permissions)
      end
      self.datastreams["rightsMetadata"]
    end

  end
end
