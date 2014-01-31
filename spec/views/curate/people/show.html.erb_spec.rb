require 'spec_helper'

describe 'curate/people/show.html.erb' do
  let(:person) { FactoryGirl.create(:person_with_user) }
  let(:user) { person.user }

  context 'A person who has a collection in their profile' do
    let(:outer_collection) { FactoryGirl.create(:collection, user: user, title: 'Outer Collection') }
    let(:inner_collection) { FactoryGirl.create(:collection, user: user, title: 'Inner Collection') }
    let(:outer_work) { FactoryGirl.create(:generic_work, user: user, title: 'Outer Work') }
    let(:inner_work) { FactoryGirl.create(:generic_work, user: user, title: 'Inner Work') }

    before do
      inner_collection.members << inner_work
      inner_collection.save!
      outer_collection.members << inner_collection
      outer_collection.save!

      person.profile.members << [outer_collection, outer_work]
      person.profile.save!
      assign :person, person
      controller.stub(:current_user).and_return(user)

      render
    end

    context 'with logged in user' do
      it 'lists the items within the outer collection, but not the inner collection' do
        assert_select '#person_profile #documents' do
          assert_select 'ul' do
            assert_select 'a[href=?]', collection_path(outer_collection), text: 'Outer Collection'
            assert_select 'a[href=?]', collection_path(inner_collection), text: 'Inner Collection'
            assert_select 'a[href=?]', curation_concern_generic_work_path(outer_work), text: 'Outer Work'
            assert_select 'a[href=?]', curation_concern_generic_work_path(inner_work), count: 0
          end
        end
      end
    end

  end

  context 'with an empty profile and not logged in' do

    before do
      assign :person, person
      controller.stub(:current_user).and_return(user)
      render
    end

    let(:user) { nil }
    it 'should render the person profile section' do
      assert_select '#person_profile' do
        assert_select '#documents', count: 0
        assert_select '#no-documents', count: 0
        assert_select '.form-action', count: 0
      end
    end
  end


end
