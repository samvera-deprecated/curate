# This module is used to take a params hash from the Work edit form (it uses nested attributes)
# and decide what action needs to happen for each editor listed in the Work.
# The possibilities are: none, create, destroy

module CurationConcern::WorkPermissionActionParser

  def self.convert_params( class_name, params )

    action = self.decide_editorship_action( class_name, params )
    self.build_params( class_name, params, action ) 
    
  end

  private
  
  # Parse the params from the Work update form and decide the action
  def self.decide_editorship_action( class_name, params )
    
    editor_action=[]
    if !params[class_name]["editors_attributes"].nil?
      
      params[class_name]["editors_attributes"].each do |key, value|
        params_action(key, value, editor_action, params)
      end
    end  

    group_action=[]
    if !params[class_name]["editor_groups_attributes"].nil?
      params[class_name]["editor_groups_attributes"].each do |key, value|
        params_action(key, value, group_action, params)
      end
    end
    
    {editors: editor_action, groups: group_action}
    
  end


  def self.params_action(key, value, action, params)
    if !value["id"].nil? and value["id"] != "" and !value["_destroy"].nil? and value["_destroy"] == ""
      action << "none" if params["commit"].include?("Update")
      action << "create" if params["commit"].include?("Create")
    elsif !value["id"].nil? and value["id"] != "" and value["_destroy"].nil?
      action << "create"
    elsif !value["id"].nil? and value["id"] != "" and !value["_destroy"].nil?
      action << "destroy"
    elsif !value["id"].nil? and value["id"] == "" and value["_destroy"].nil?
      action << "none"
    end
  end
  
  # Build the param hash to be used by WorkEditorship
  def self.build_params( class_name, params, action )
    editor_params_aggregate = []
    group_params_aggregate = []
    
    if action.has_key?(:editors)
      action[:editors].each_with_index do |editor_action, index|
        person_id = params[class_name]["editors_attributes"][index.to_s]["id"]
        if person_id
          editor_params_aggregate << Hash[person_id: person_id, action: editor_action]
        end
      end
    end

    if action.has_key?(:groups)
      action[:groups].each_with_index do |group_action, index|
        group_id = params[class_name]["editor_groups_attributes"][index.to_s]["id"]
        if group_id
          group_params_aggregate << Hash[group_id: group_id, action: group_action]
        end
      end
    end

    { work_id: params[:id], editors: editor_params_aggregate, editor_groups: group_params_aggregate }
  end
  
end
