module CurationConcern
  module WithAccessRight
    extend ActiveSupport::Concern

    included do
      attr_accessor :visibility
    end

    def open_access?
      access_rights.open_access?
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
