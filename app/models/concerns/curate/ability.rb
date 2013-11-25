module Curate
  module Ability
    extend ActiveSupport::Concern
    included do
      self.ability_logic += [:curate_permissions]
    end

    def curate_permissions
      alias_action :confirm, :copy, :to => :update
      can :edit, Person do |p| 
        p.pid == current_user.repository_id
      end

      can [:show, :read, :update, :destroy], [Curate.configuration.curation_concerns] do |w|
        u = ::User.find_by_user_key(w.owner)
        u && u.can_receive_deposits_from.include?(current_user)
      end
    end

  end
end

