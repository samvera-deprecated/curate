require 'spec_helper'

describe 'curate/collections/_form_to_add_member.html.erb' do
  let(:profile)         { double(title: 'Your Profile',      pid: 'sufia:abcde', noid: 'abcde') }
  let(:collectible)     { double(title: 'A Document',        pid: 'sufia:vwxyz', noid: 'vwxyz') }
  let(:profile_section) { double(title: 'A Profile Section', pid: 'sufia:56789', noid: '56789') }

  before do
    view.stub(:current_users_profile_sections).and_return([profile_section])
    view.stub(:available_collections).and_return([])
    view.stub(:available_profiles).and_return([profile])

    render partial: 'form_to_add_member', locals: { collectible: collectible }
  end

  it 'should list profile and profile sections in the dropdown menu' do
    expect(rendered).to include(profile.title)
    expect(rendered).to include(profile_section.title)
  end

end
