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
    rubydora_purge_object = self.instance_method(:purge_object)

    before_purge_object do |options|
      find(options[:pid]).datastreams.each do |key, value|
        purge_datastream({pid: options[:pid], dsid: key})
      end
      client[object_url(options[:pid],state: ActiveFedora::DELETED_STATE)].put(nil)
      raise PerformedSoftDelete.new('purge_object', options[:pid], options)
    end

    define_method(:purge_object) { |*args|
      begin
        rubydora_purge_object.bind(self).call(*args)
      rescue PerformedSoftDelete
        true
      end
    }

    rubydora_purge_datastream = self.instance_method(:purge_datastream)

    before_purge_datastream do |options|
      client[datastream_url(options[:pid], options[:dsid], dsState: ActiveFedora::DELETED_STATE )].put(nil)
      raise PerformedSoftDelete.new('purge_datastream', options[:pid], options)
    end

    define_method(:purge_datastream) { |*args|
      begin
        rubydora_purge_datastream.bind(self).call(*args)
      rescue PerformedSoftDelete
        true
      end
    }

    rubydora_purge_relationship = self.instance_method(:purge_relationship)

    before_purge_relationship do |options|
      client[object_relationship_url(options[:pid], state: ActiveFedora::DELETED_STATE)].put(nil)
      raise PerformedSoftDelete.new('purge_relationship', options[:pid], options)
    end

    define_method(:purge_relationship) { |*args|
      begin
        rubydora_purge_relationship.bind(self).call(*args)
      rescue PerformedSoftDelete
        true
      end
    }

  end
end

module ActiveFedora
  DELETED_STATE = 'D'
  class ActiveObjectNotFoundError < ObjectNotFoundError
    def initialize(pid)
      super("Unable to find active '#{pid}' in fedora.")
    end
  end

  class Base
    active_fedora_delete = self.instance_method(:delete)
    define_method(:delete) do
      @pid_before_delete = pid
      active_fedora_delete.bind(self).call
    end
    active_fedora_destroy = self.instance_method(:destroy)
    define_method(:destroy) do
      @pid_before_delete = pid
      active_fedora_destroy.bind(self).call
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
