require 'singleton'

module ActiveDomain
  class TooManyArgumentsError < StandardError
  end

  class ProjectionRegistry
    include Singleton

    def self.register(event_handler)
      self.registry << event_handler
    end

    def self.invoke(event)
      instance.invoke event
    end

    def invoke(event)
      event_type = event.class.name.split('::').last.to_sym
      return unless handlers.has_key? event_type
      handlers[event_type].each do |handler_method|
        handler_method.owner.new.send handler_method.name, event
      end
    end

    private

    cattr_accessor :registry
    attr_accessor :handlers

    def initialize
      self.handlers = Hash.new do |hash, key|
        hash[key] = []
      end
      self.class.registry.freeze.each do |handler|
        handler.public_instance_methods(false).each do |method_name|
          method = handler.instance_method method_name
          event_type = method_name.to_s.camelcase.to_sym
          raise TooManyArgumentsError if 1 != method.arity
          handlers[event_type] << method
        end
      end
      handlers.freeze
    end

    self.registry = []
  end
end