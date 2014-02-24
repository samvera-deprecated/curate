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
        @manager_usernames ||= YAML.load(ERB.new(Rails.root.join('config/manager_usernames.yml').read).result)[Rails.env]['manager_usernames']
      end

      def name
        read_attribute(:name) || user_key
      end
    end
  end
end
