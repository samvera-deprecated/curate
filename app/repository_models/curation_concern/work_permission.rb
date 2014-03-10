require 'virtus'
class CurationConcern::WorkPermission
  include Virtus.model
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attribute :current_user, User
  attribute :work_id, String
  attribute :editors, Array
  attribute :editor_groups, Array

  def work
    @work ||= ActiveFedora::Base.find(work_id, cast: true) 
  end

  def person(person_id)
    @person = Person.find(person_id)
  end

  def editor_group(group_id)
    @group = Hydramata::Group.find(group_id)
  end

  def save
    valid? ? persist : false
  end

  private
  def persist
    update_editors
    update_groups
    work.save
  end

  def update_editors
    self.editors.each do |editor|
      if editor[:action] == 'create'
        work.add_editor( person( editor[:person_id] ) )
      elsif editor[:action] == 'destroy'
        work.remove_editor( person( editor[:person_id] ) )
      end
    end
  end

  def update_groups
    self.editor_groups.each do |grp|
      if grp[:action] == 'create'
        work.add_editor_group( editor_group( grp[:group_id] ) )
      elsif grp[:action] == 'destroy'
        work.remove_editor_group( editor_group( grp[:group_id] ) )
      end
    end
  end
end
