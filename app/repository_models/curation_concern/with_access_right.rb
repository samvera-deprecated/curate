module CurationConcern
  module WithAccessRight
    extend ActiveSupport::Concern

    included do
      attr_accessor :visibility
    end

    def open_access_rights?
      access_rights.open_access?
    end

    def authenticated_only_rights?
      access_rights.authenticated_only?
    end

    def private_rights?
      access_rights.private?
    end

    def access_rights
      @access_rights ||= AccessRight.new(self)
    end
    protected :access_rights

  end
end
