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

      can [:show, :read, :update, :destroy], [GenericWork, Article] do |w|
        puts "TRYING #{w.pid}"
        u = ::User.find_by_user_key(w.owner)

        vals = u && u.can_receive_deposits_from
        vals.include?(current_user)
      end
    end

  end
end

