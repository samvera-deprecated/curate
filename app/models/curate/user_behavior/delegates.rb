module Curate::UserBehavior::Delegates
  extend ActiveSupport::Concern
  included do
    has_many :deposit_rights_given, foreign_key: 'grantor_id', class_name: 'Curate::ProxyDepositRights', dependent: :destroy
    has_many :can_receive_deposits_from, through: :deposit_rights_given, source: :grantee

    has_many :deposit_rights_received, foreign_key: 'grantee_id', class_name: 'Curate::ProxyDepositRights', dependent: :destroy
    has_many :can_make_deposits_for, through: :deposit_rights_received, source: :grantor
  end
end
