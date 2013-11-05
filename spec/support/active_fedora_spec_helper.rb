module ActiveFedora
  module SpecHelper
    class << self
      def register_persistence(object)
        puts object.pid
        registry << object
      end

      def registry
        @registry ||= Set.new
      end

      def cleanup!
        cleanup_fedora!
        cleanup_solr!
      end

      def cleanup_fedora!
        registry.each {|obj| obj.delete rescue true }
      end

      def cleanup_solr!
        solr = ActiveFedora::SolrService.instance.conn
        solr.delete_by_query("*:*", params: {commit: true})
        solr.commit
      end
    end

    extend ActiveSupport::Concern

    included do
      after_create {|obj| ActiveFedora::SpecHelper.register_persistence(obj) }
    end

  end
end
