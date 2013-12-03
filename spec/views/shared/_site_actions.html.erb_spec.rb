require 'spec_helper'

describe 'shared/_site_actions.html.erb' do

  before(:each) do
    view.stub(:current_user).and_return(current_user)
    render partial: 'shared/site_actions.html.erb'
  end

  def have_login_section
    have_tag('.login', with: { href: new_user_session_path } )
  end

  def have_add_content_section(&block)
    have_tag('.add-content', &block)
  end

  def have_my_actions_section(&block)
    have_tag('.my-actions', &block)
  end

  context 'logged in' do
    let(:person) { double(pid: 'test:1234') }
    let(:name) { 'My Display Name' }
    let(:current_user) { User.new(name: name, person: person).tap {|u| u.stub(groups: ['registered'])} }
    it 'renders a link to create a new user session' do
      expect(rendered).to_not have_login_section
      expect(rendered).to have_add_content_section do
        with_tag '.quick-create' do
          with_tag 'a.link-to-full-list', with: { href: new_classify_concern_path }
          with_tag 'a.contextual-quick-classify', minimum: 3
          with_tag 'a.new-collection', with: { href: new_collection_path }, text: 'Add a Collection'
        end
      end
      expect(rendered).to have_my_actions_section do
        with_tag '.my-actions' do
          with_tag 'a.user-display-name', text: /#{name}/
          with_tag '.dropdown-menu' do
            with_tag 'a.my-works'
            with_tag 'a.my-collections', with: { href: collections_path}
            with_tag 'a.my-account', with: { href: user_profile_path }
            with_tag 'a.my-proxies', with: { href: person_depositors_path('1234') }
            with_tag 'a.log-out', with: { href: destroy_user_session_path }
          end
        end
      end
    end
  end

  context 'not logged in' do
    let(:current_user) { nil }
    it 'renders a link to create a new user session' do
      expect(rendered).to_not have_add_content_section
      expect(rendered).to_not have_my_actions_section
      expect(rendered).to have_login_section
    end
  end
end
