require 'spec_helper'

describe 'curation_concern/base/_linked_editors.html.erb' do

  let(:person) { FactoryGirl.create(:person_with_user) }
  let(:user) { person.user }
  let(:contributor_agreement) { double( :contributor_agreement, param_key: :accept_contributor_agreement, acceptance_value: 'accept', param_value: 'accept' ) }
  context 'New Work' do
    let(:work) { FactoryGirl.build(:generic_work, title: 'work 1') }
    before(:each) do
      controller.stub(:current_user).and_return(user)
      assign(:curation_concern, work)
      render partial: 'form', locals: {curation_concern: work, contributor_agreement: contributor_agreement}
    end
    it 'should have editor in its own fieldset' do
      expect(rendered).to have_selector('fieldset#set-editors div#editors')
    end
  end
end
