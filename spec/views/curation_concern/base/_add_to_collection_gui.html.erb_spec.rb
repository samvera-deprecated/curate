require 'spec_helper'

describe 'curation_concern/base/_add_to_collection_gui' do
  let(:curation_concern) { FactoryGirl.create(:generic_work) }
  let(:current_user) { double(name: name, person: person) }
  let(:name) { 'My Display Name'}
  let(:person) { FactoryGirl.create(:person_with_user) }
  let(:user) { person.user }

  context 'with collections' do
    before do
      assign :person, person
      controller.stub(:current_user).and_return(user)
      render partial: 'add_to_collection_gui', locals: { collectible: curation_concern }
    end

    it 'displays the link to add work to a collection' do
      rendered.should have_link('Add to Collection', add_member_form_collections_path(collectible_id: curation_concern.pid))
    end
  end

  context 'with no collections' do
    before do
      assign :person, person
      controller.stub(:current_user).and_return(nil)
      render partial: 'add_to_collection_gui', locals: { collectible: curation_concern }
    end

    it 'displays no link' do
      rendered.should_not have_link('Add to Collection')
    end
  end

end
