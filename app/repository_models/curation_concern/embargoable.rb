require File.expand_path('../../../validators/future_date_validator', __FILE__)
module CurationConcern
  module Embargoable
    extend ActiveSupport::Concern

    included do
      validates :embargo_release_date, future_date: true
      before_save :write_embargo_release_date, prepend: true
    end

    def write_embargo_release_date
      if defined?(@embargo_release_date)
        embargoable_persistence_container.embargo_release_date = embargo_release_date
      end
      true
    end
    protected :write_embargo_release_date

    def embargo_release_date=(value)
      @embargo_release_date = begin
        value.to_date
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
