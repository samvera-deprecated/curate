require 'virtus'
class CurationConcern::WorkEditorship
  include Virtus.model
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attribute :current_user, User
  attribute :work_id, String
  attribute :editors, Array

  def work
    @work ||= ActiveFedora::Base.find(work_id, cast: true) 
  end

  def person(person_id)
    @person = Person.find(person_id)
  end

  def save
    valid? ? persist : false
  end

  private
  def persist
    self.editors.each do |editor|
      if editor[:action] == 'create'
        work.add_editor( person( editor[:person_id] ) )
      elsif editor[:action] == 'destroy'
        work.remove_editor( person( editor[:person_id] ) )
      end
    end
    work.save
  end
end
