require 'spec_helper'

describe 'shared/_site_actions.html.erb' do

  before(:each) do
    render partial: 'shared/site_actions.html.erb', locals: {current_user: current_user}
  end

  def have_login_section
    have_tag('.nav-pills a.btn', with: { href: new_user_session_path } )
  end

  def have_add_content_section(&block)
    have_tag('.add-content', &block)
  end

  def have_my_actions_section(&block)
    have_tag('.my-actions', &block)
  end

  context 'logged in' do
    let(:person) { double }
    let(:name) { 'My Display Name' }
    let(:current_user) { double(name: name, person: person) }
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
            with_tag 'a.my-account', with: { href: person_path(person) }
            with_tag 'a.my-proxies', with: { href: person_depositors_path(person) }
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
