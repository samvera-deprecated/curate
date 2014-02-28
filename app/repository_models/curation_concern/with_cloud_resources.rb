module CurationConcern
  module WithCloudResources
    extend ActiveSupport::Concern

    unless included_modules.include?(ActiveFedora::RegisteredAttributes)
      include ActiveFedora::RegisteredAttributes
    end

    included do
      attribute :cloud_resource_urls, multiple: true
    end

  end
end

