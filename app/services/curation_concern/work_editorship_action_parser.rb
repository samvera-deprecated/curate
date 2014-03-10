# This module is used to take a params hash from the Work edit form (it uses nested attributes)
# and decide what action needs to happen for each editor listed in the Work.
# The possibilities are: none, create, destroy

module CurationConcern::WorkEditorshipActionParser

  def self.convert_params( class_name, params )

    action = self.decide_editorship_action( class_name, params )
    self.build_params( class_name, params, action ) 
    
  end

  private
  
  # Parse the params from the Work update form and decide the action
  def self.decide_editorship_action( class_name, params )
    
    action=[]
    #validate prescence of required params 
    if !params[class_name]["editors_attributes"].nil?
      
      params[class_name]["editors_attributes"].each do |key, value|
        if !value["id"].nil? and value["id"] != "" and !value["_destroy"].nil? and value["_destroy"] == ""
          #do nothing with editorship
          action << "none" if params["commit"].include?("Update")
          action << "create" if params["commit"].include?("Create")
        elsif !value["id"].nil? and value["id"] != "" and value["_destroy"].nil?
          #add editor
          action << "create"
        elsif !value["id"].nil? and value["id"] != "" and !value["_destroy"].nil?
          #remove editor
          action << "destroy"
        elsif !value["id"].nil? and value["id"] == "" and value["_destroy"].nil?
          #empty member field, do nothing with editorship
          action << "none"
        end
      end
      
    end
    
    action
    
  end
  
  # Build the param hash to be used by WorkEditorship
  def self.build_params( class_name, params, action )
    new_params_aggregate = []
    
    action.each_with_index do |editor_action, index|
      person_id = params[class_name]["editors_attributes"][index.to_s]["id"]
      if person_id
        new_params_hash = Hash[person_id: person_id, action: editor_action]
        new_params_aggregate << new_params_hash
      end
    end
    { work_id: params[:id], editors: new_params_aggregate }
  end
  

end
