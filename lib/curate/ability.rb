module Curate
  module Ability
    extend ActiveSupport::Concern
    included do
      self.ability_logic += [:curate_permissions]
    end

    def curate_permissions
      alias_action :confirm, :copy, :to => :update
    end

  end
end

