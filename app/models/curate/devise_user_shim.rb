module Curate
  #
  # Here there be Dragons!
  #
  # These are the methods, to the best of my ability, that are necessary to
  # use the base class as a replacement for User.
  #
  # Why might we want to do this?
  # Because who knows what all needs to happen when a user is created, and we
  # want to detangle the user creation/maintenance process.
  #
  module DeviseUserShim
    extend ActiveSupport::Concern


    def wrapping_class
      @wrapping_class
    end

    def wrapping_class=(value)
      @wrapping_class = value
    end
    module_function :wrapping_class, :wrapping_class=


    included do
      class_attribute :wrapped_class
      DeviseUserShim.wrapping_class = self
    end

    # Because Devise is violating the Law of Demeter via the following line:
    # `resource_class.to_adapter.get!(*args)` we have this wonderful work around
    module ToAdaptorShim
      def get!(*args)
        DeviseUserShim.wrapping_class.new(super(*args))
      end
    end

    module ClassMethods

      def is_a?(comparison)
        super || wrapped_class.is_a?(comparison)
      end

      def devise
        wrapped_class.devise
      end

      def password_length
        wrapped_class.password_length
      end

      def authentication_keys
        wrapped_class.authentication_keys
      end

      def new_with_session(attributes, session)
        user = wrapped_class.new_with_session({}, session)
        new(user, attributes)
      end

      def to_adapter
        adapter = wrapped_class.to_adapter
        adapter.extend(ToAdaptorShim)
        adapter
      end
    end
  end
end