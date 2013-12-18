module Curate
  module UserBehavior
    module Base
      extend ActiveSupport::Concern

      included do
        has_many :authentications, dependent: :destroy
      end

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

      def name
        read_attribute(:name) || user_key
      end

      def apply_omniauth(omni)
        authentication = authentications.build(:provider => omni['provider'],
             :uid => omni['uid'],
             :token => omni['credentials'].token,
             :token_secret => omni['credentials'].secret)
      end

      def password_required?
        (authentications.empty? || !password.blank?) && super
      end

      def update_with_password(params, *options)
        if encrypted_password.blank?
          update_attributes(params, *options)
        else
          super
        end
      end
    end
  end
end
