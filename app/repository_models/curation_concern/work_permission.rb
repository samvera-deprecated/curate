class CurationConcern::WorkPermission
  def self.create(work, action, editors, groups)
    update_editors(work, editors, action)
    update_groups(work, groups, action)
    true
  end

  private

    def self.decide_editorship_action(attributes_collection, action_type)
      sorted = { remove: [], create: [] }
      return sorted unless attributes_collection
      if attributes_collection.is_a? Hash
        keys = attributes_collection.keys
        attributes_collection = if keys.include?('id') || keys.include?(:id)
          Array(attributes_collection)
        else
          attributes_collection.sort_by { |i, _| i.to_i }.map { |_, attributes| attributes }
        end
      end

      attributes_collection.each do |attributes|
        if attributes['id'].present?
          if has_destroy_flag?(attributes)
            sorted[:remove] << attributes['id']
          elsif action_type == :create || action_type == :update
            sorted[:create] << attributes['id']
          end
        end
      end

      sorted
    end

    private
    def self.has_destroy_flag?(hash)
      ["1", "true"].include?(hash['_destroy'].to_s)
    end
<<<<<<< HEAD


    def self.user(person_id)
      ::User.find_by_repository_id(person_id)
    end

    def self.editor_group(group_id)
      Hydramata::Group.find(group_id)
    end

=======
    

    def self.user(person_id)
      ::User.find_by_repository_id(person_id)
    end

    def self.editor_group(group_id)
      Hydramata::Group.find(group_id)
    end

>>>>>>> develop

    def self.update_editors(work, editors, action)
      collection = decide_editorship_action(editors, action)
      work.remove_editors(collection[:remove].map { |u| user(u) })
      work.add_editors(collection[:create].map { |u| user(u) })
    end

    # This is extremely expensive because add_editor_group causes a save each time.
    def self.update_groups(work, editor_groups, action)
      collection = decide_editorship_action(editor_groups, action)
      work.remove_editor_groups(collection[:remove].map { |grp| editor_group(grp) })
      work.add_editor_groups(collection[:create].map { |grp| editor_group(grp) })
    end
end
