module Curate
  module Ability
    extend ActiveSupport::Concern
    included do
      self.ability_logic += [:curate_permissions, :collection_permissions]
    end

    def curate_permissions
      alias_action :confirm, :copy, :to => :update
      if current_user.manager?
        can [:discover, :show, :read, :edit, :update, :destroy], :all
      end

      can :edit, Person do |p|
        p.pid == current_user.repository_id
      end

      can [:show, :read, :update, :destroy], [Curate.configuration.curation_concerns] do |w|
        u = ::User.find_by_user_key(w.owner)
        u && u.can_receive_deposits_from.include?(current_user)
        end
    end

    def collection_permissions
      can :collect, :all
    end

    # Overriding hydra-access-controls in order to enforce embargo
    def read_permissions
      can :read, String do |pid|
        test_read(pid)
      end
      
      # Had to add obj to params because test_read needs to check embargo
      can :read, ActiveFedora::Base do |obj|
        test_read(obj.pid, obj)
      end 
      
      can :read, SolrDocument do |obj|
        cache.put(obj.id, obj)
        test_read(obj.id)
      end 
    end

    # Overriding the test_read method from hydra-access-control's ability.rb
    def test_read(pid, work)
      byebug
      logger.debug("TEST [CANCAN] Checking read permissions for user: #{current_user.user_key} with groups: #{user_groups.inspect}")
      if work.under_embargo? && current_user.user_key == work.owner
        #only owner has read access
        result = true
      elsif work.under_embargo? && current_user.user_key != work.owner
        result = false
      # not under embargo
      else
        group_intersection = user_groups & read_groups(pid)
        result = !group_intersection.empty? && read_persons(pid).include?(current_user.user_key)
      end

      result
    end 

  end
end

