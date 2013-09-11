module Curate
  module User
    extend ActiveSupport::Concern
    included do
      include Curate::User::Base
      include Curate::User::WithAssociatedPerson
    end
  end
end
