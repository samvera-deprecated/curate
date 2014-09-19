module Curate
  module UserBehavior
    module Base
      extend ActiveSupport::Concern

      def repository_noid
        Sufia::Noid.noidify(repository_id)
      end

      def repository_noid?
        repository_id?
      end

      def agree_to_terms_of_service!
        update_column(:agreed_to_terms_of_service, true)
      end

      def collections
        Collection.where(Hydra.config[:permissions][:edit][:individual] => user_key)
      end

      def get_value_from_ldap(attribute)
        # override
      end

      def manager?
        manager_usernames.include?(user_key)
      end

      def manager_usernames
        @manager_usernames ||= load_managers
      end

      def name
        read_attribute(:name) || user_key
      end

      def groups
        person.group_pids
      end

      private

        def load_managers
          manager_config = "#{::Rails.root}/config/manager_usernames.yml"
          if File.exist?(manager_config)
            content = IO.read(manager_config)
            YAML.load(ERB.new(content).result).fetch(Rails.env).
              fetch('manager_usernames')
          else
            logger.warn "Unable to find managers file: #{manager_config}"
            []
          end
        end
    end
  end
end
