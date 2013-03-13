require 'rubydora/repository'
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

  class Repository

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
          soft_purge_datastreams(options[:pid])
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

      # Because the delete happens and the pid is lost, the datastreams should
      # be cleared.
      def soft_purge_datastreams(pid)
        find(pid).datastreams.each do |key, value|
          purge_datastream({pid: pid, dsid: key})
        end
      end
      private :soft_purge_datastreams
    end

    include SoftDeleteBehavior
  end
end

module ActiveFedora
  DELETED_STATE = 'D'
  class ActiveObjectNotFoundError < ObjectNotFoundError
    def initialize(pid)
      super("Unable to find active '#{pid}' in fedora.")
    end
  end

  class DigitalObject
    class << self
      active_fedora_digital_object_find = self.instance_method(:find)
      define_method(:find) do |*args|
        returning_value = active_fedora_digital_object_find.bind(self).call(*args)
        if returning_value.state == ActiveFedora::DELETED_STATE
          raise ActiveFedora::ActiveObjectNotFoundError.new(returning_value.pid)
        end
        returning_value
      end
    end
  end
end
