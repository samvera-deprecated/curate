module ActiveFedora
  module TestCleaner
    extend ActiveSupport::Concern

    included do
      after_create do |obj|
        ActiveFedora::TestCleaner.register(obj)
      end
    end
    module_function

    def setup
      unless ActiveFedora::Base.included_modules.include?(ActiveFedora::TestCleaner)
        ActiveFedora::Base.send(:include, ActiveFedora::TestCleaner)
      end
    end

    def start
      @registry = nil
    end

    def register(obj)
      registry << obj.pid
    end

    def registry
      @registry ||= Set.new
    end

    def clean
      registry.each do |pid|
        # By referencing the inner object we can skip any delete callbacks and
        # SOLR cleaning
        ActiveFedora::Base.find(pid, cast: false).inner_object.delete rescue true
      end
      if registry.size > 0
        solr = ActiveFedora::SolrService.instance.conn
        solr.delete_by_query("*:*", params: {commit: true})
      end
    ensure
      @registry = nil
    end
  end
end
