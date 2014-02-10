# This module is used to take a params hash from the Group edit form (it uses nested attributes)
# and decide what action needs to happen for each member listed in the Group.
# The possibilities are: none, create, destroy

module Hydramata::GroupMembershipActionParser

  def self.convert_params(params)

     action = self.decide_membership_action(params)
     self.build_params(params, action) 
    
  end

  private
  
  # Parse the params from the Group update form and decide the action
  def self.decide_membership_action(params)
    
    action=[]
    #validate prescence of required params 
    if !params["hydramata_group"]["title"].nil? and !params["hydramata_group"]["description"].nil? and !params["hydramata_group"]["members_attributes"].nil?
      
      params["hydramata_group"]["members_attributes"].each do |key, value|
        if !value["id"].nil? and !value["_destroy"].nil? and value["_destroy"] == ""
          #do nothing with membership
          action << "none"
        elsif !value["id"].nil? and value["id"] != "" and value["_destroy"].nil?
          #add member
          action << "create"
        elsif !value["id"].nil? and value["id"] != "" and !value["_destroy"].nil?
          #remove member
          action << "destroy"
        elsif !value["id"].nil? and value["id"] == "" and value["_destroy"].nil?
          #empty member field, do nothing with membership
          action << "none"
        else
          raise Exception, "Exception placeholder"
        end
      end
      
    else
      raise Exception, "Exception placeholder"
    end
    
    action
    
  end
  
  # Build the param hash to be used by GroupMembershipForm 
  def self.build_params(params, action)
    new_params_aggregate = []
    
    action.each_with_index do |member_action, index|
      person_id = params["hydramata_group"]["members_attributes"][index.to_s]["id"]
      if person_id
        role = params["group_member"]["edit_users_ids"].include?(person_id) ? "manager" : "member"
        new_params_hash = Hash[person_id: person_id, action: member_action, role: role]
        new_params_aggregate << new_params_hash
      end
    end
    { group_id: params[:id], title: params["hydramata_group"]["title"], description: params["hydramata_group"]["description"], members: new_params_aggregate }
  end
  

end
