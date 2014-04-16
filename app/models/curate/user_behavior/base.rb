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
        username = self.respond_to?(:username) ? self.username : self.to_s
        !!manager_usernames.include?(username)
      end

      def manager_usernames
        manager_config = 'config/manager_usernames.yml'
        @manager_usernames ||= begin
          if File.exist?(manager_config)
            content = Rails.root.join(manager_config).read
            YAML.load(ERB.new(content).result).fetch(Rails.env).
              fetch('manager_usernames')
          else
            []
          end
        end
      end

      def name
        read_attribute(:name) || user_key
      end

      def groups
        self.person.group_pids
      end
    end
  end
end
