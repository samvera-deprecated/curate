require 'spec_helper'

describe 'curate/collections/_form_to_add_member.html.erb' do
  let(:collectible) { FactoryGirl.create(:generic_work, user: user) }
  let(:person) { FactoryGirl.create(:person_with_user) }
  let(:user) { person.user }
  let(:profile) { person.profile }
  let(:profile_section) {double(title: 'Section 1', pid: '123')}

  before do
    assign :collection_options, [collectible]
    assign(:available_profiles, view.stub(:available_profiles).and_return([profile]))
    assign(:current_users_profile_sections, view.stub(:current_users_profile_sections).and_return([profile_section]))
    render partial: 'form_to_add_member', locals: { collectible: collectible, fieldset_class: 'with-side-padding with-top-padding' }
  end

  it 'should list profile and profile sections in the dropdown menu' do
    expect(rendered).to have_content(profile.title)
    expect(rendered).to have_content("Section 1")
  end
end
