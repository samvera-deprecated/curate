require 'spec_helper'

describe 'curation_concern/base/_collection.html.erb' do
  let(:curation_concern) { FactoryGirl.create(:generic_work, user: user) }
  let(:current_user) { double(name: name, person: person) }
  let(:name) { 'My Display Name'}
  let(:person) { FactoryGirl.create(:person_with_user) }
  let(:user) { person.user }
  let(:collection) { FactoryGirl.create(:collection, user: user, title: 'Collection 1') }

  context 'logged in' do
    before do
      curation_concern.collections << collection
      curation_concern.save!
      assign :person, person
      controller.stub(:current_user).and_return(user)
      render partial: 'collections', curation_concern: curation_concern, locals: { curation_concern: curation_concern }
    end

    it 'lists all the collections the work is added to' do
      expect(rendered).to include("Collection 1")
    end
  end

  context 'public view:' do
    before do
      curation_concern.collections << collection
      curation_concern.save!
      assign :person, person
      controller.stub(:current_user).and_return(nil)
      render partial: 'collections', curation_concern: curation_concern, locals: { curation_concern: curation_concern }
    end

    it 'lists all the collections the work is added to' do
      expect(rendered).to include("Collection 1")
    end
  end
end
