
require 'rubydora/repository'
require 'rubydora/rest_api_client'
require 'active_fedora/digital_object'
require 'active_fedora/base'

module Rubydora
  class PerformedSoftDelete < RuntimeError
    attr_reader :options
    def initialize(method_name, pid, options)
      @options = options
      super("Performed soft delete on '#{pid}' via '#{method_name}'")
    end
  end

   module RestApiClient

    # There is likely a better way of doing this, but the ActiveFedora API doesn't
    # appear to support soft-deletes (i.e. changing the state to 'D')
    #
    # So I am intercepting the :purge_object, :purge_datastream, and
    # :purge_relationship methods and instead of purging, I'm modifying.
    # the state.
    module SoftDeleteBehavior
      extend ActiveSupport::Concern

      included do
        before_purge_object do |options|
          client[object_url(options[:pid],state: ActiveFedora::DELETED_STATE)].put(nil)
          raise PerformedSoftDelete.new('purge_object', options[:pid], options)
        end
        before_purge_datastream do |options|
          client[datastream_url(options[:pid], options[:dsid], dsState: ActiveFedora::DELETED_STATE )].put(nil)
          raise PerformedSoftDelete.new('purge_datastream', options[:pid], options)
        end

        before_purge_relationship do |options|
          client[object_relationship_url(options[:pid], state: ActiveFedora::DELETED_STATE)].put(nil)
          raise PerformedSoftDelete.new('purge_relationship', options[:pid], options)
        end
      end

      def purge_object(*args)
        super(*args) rescue PerformedSoftDelete; true
      end
      def purge_datastream(*args)
        super(*args) rescue PerformedSoftDelete; true
      end
      def purge_relationship(*args)
        super(*args) rescue PerformedSoftDelete; true
      end
    end

  end

  class Fc3Service
    include Rubydora::RestApiClient unless included_modules.include?(RestApiClient)
    include Rubydora::RestApiClient::SoftDeleteBehavior
  end
end

module ActiveFedora
  DELETED_STATE = 'D'
  class ActiveObjectNotFoundError < RuntimeError
    attr_reader :base_exception
    def initialize(exception, *args)
      @base_exception = exception
      super("Unable to find via #{args.inspect} in fedora.")
    end
  end

  class Base
    module SoftDeleteBehavior
      def exists?(*args)
        super
      rescue ActiveObjectNotFoundError, RestClient::Unauthorized
        true
      end
    end

    extend SoftDeleteBehavior
  end

  class DigitalObject
    # Application level enforcement of finding a DELETE_STATE object
    module SoftDeleteBehavior
      # Because I don't want to be handling RestClient::Unauthorized in a
      # controller, I want to change the exception to a more meaningful
      # exception
      def find(*args)
        super
      rescue RestClient::Unauthorized => e
        raise ActiveObjectNotFoundError.new(e, *args)
      end
    end

    extend SoftDeleteBehavior
  end
end





