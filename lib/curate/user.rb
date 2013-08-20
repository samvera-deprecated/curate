module Curate
  module User
    def agree_to_terms_of_service!
      update_column(:agreed_to_terms_of_service, true)
    end
  end
end