class Curate::PeopleController < ApplicationController
  respond_to :html
  with_themed_layout

  before_filter :breadcrumb

  def person
    @person ||= Person.find(params[:id])
  end
  protected :person

  def person_has_a_name?
    person.name && !person.name.empty?
  end
  protected :person_has_a_name?

  def breadcrumb
    link_name = person_has_a_name? ? person.name : 'Person'
    add_breadcrumb link_name, person_path(person)
  end
  protected :breadcrumb

end
