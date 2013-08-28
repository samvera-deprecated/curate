module CurationConcern
  module WithAccessRight
    extend ActiveSupport::Concern

    included do
      require 'morphine'
      include Morphine
      register :embargoable_persistence_container do
        if ! self.class.included_modules.include?('Sufia::GenericFile::Permissions')
          self.class.send(:include, Sufia::GenericFile::Permissions)
        end
        self.datastreams["rightsMetadata"]
      end
    end

    def under_embargo?
      @under_embargo ||= rightsMetadata.under_embargo?
    end

    def open_access?
      access_rights.open_access?
    end

    def open_access_with_embargo_release_date?
      access_rights.open_access_with_embargo_release_date?
    end

    def authenticated_only_access?
      access_rights.authenticated_only?
    end

    def private_access?
      access_rights.private?
    end

    def access_rights
      @access_rights ||= AccessRight.new(self)
    end
    protected :access_rights

  end
end
