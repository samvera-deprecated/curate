module Curate::PeopleHelper 

  def person_name_or_stub(person)
    person_has_a_name?(person) ? person.name : 'Person'
  end

  def person_has_a_name?(person)
    person.name && !person.name.empty?
  end

  def profile_has_contents?(person)
    person.profile && !person.profile.members.empty?
  end

end
