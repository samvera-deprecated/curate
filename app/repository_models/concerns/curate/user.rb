module Curate
  module User
    extend ActiveSupport::Concern

    include WithAssociatedPerson

    def agree_to_terms_of_service!
      update_column(:agreed_to_terms_of_service, true)
    end

    def collections
      Collection.where(Hydra.config[:permissions][:edit][:individual] => user_key)
    end

    def get_value_from_ldap(attribute)
      # override
    end 

  end
end
