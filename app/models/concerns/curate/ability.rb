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
    def edit_permissions  
      can [:edit, :update, :destroy], String do |pid|
        test_edit(pid)
      end 

      can [:edit, :update, :destroy], ActiveFedora::Base do |obj|
        test_edit(obj.pid, obj)
      end
   
      can :edit, SolrDocument do |obj|
        cache.put(obj.id, obj)
        test_edit(obj.id)
      end       
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

    # Overriding the test_edit method from hydra-access-control's ability.rb
    def test_edit(pid, work)
      logger.debug("[CANCAN] Checking edit permissions for user: #{current_user.user_key} with groups: #{user_groups.inspect}")
      
      # Under embargo and the current user is the owner of the work
      if work.under_embargo? && current_user.user_key == work.owner
        result = true

      # Under embargo and the current user isn't the owner of the work
      elsif work.under_embargo? && current_user.user_key != work.owner
        result = false
      
      # Not under embargo, using the default hydra-acess-controls check
      else
        group_intersection = user_groups & edit_groups(pid)
        result = !group_intersection.empty? || edit_persons(pid).include?(current_user.user_key)
      end

      logger.debug("[CANCAN] decision: #{result}")
      result
    end   

    # Overriding the test_read method from hydra-access-control's ability.rb
    def test_read(pid, work)
      logger.debug("[CANCAN] Checking read permissions for user: #{current_user.user_key} with groups: #{user_groups.inspect}")
      
      # Under embargo and the current user is the owner of the work
      if work.under_embargo? && current_user.user_key == work.owner
        result = true
      
      # Under embargo and the current user isn't the owner of the work
      elsif work.under_embargo? && current_user.user_key != work.owner
        result = false
      
      # Not under embargo, using the default hydra-acess-controls check
      else
        group_intersection = user_groups & read_groups(pid)
        result = !group_intersection.empty? && read_persons(pid).include?(current_user.user_key)
      end
      
      logger.debug("[CANCAN] decision: #{result}")
      result
    end 

  end
end

