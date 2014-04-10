require 'spec_helper'

describe 'catalog/_facets.html.erb' do
  let(:blacklight_config) { Blacklight::Configuration.new }
  before do
    view.stub(:current_user).and_return(current_user)
    view.stub(blacklight_config: blacklight_config)
    view.stub(:search_action_url) do |*args|
      catalog_index_url *args
    end
    render
  end

  context 'with logged in user' do
    let(:person) { double(pid: 'test:1234') }
    let(:name) { 'My Display Name' }
    let(:current_user) { User.new(name: name, person: person)}
    it 'should list content selection button' do
      expect(rendered).to have_tag('.search-scope')
    end
  end

  context 'with not logged in user' do
    let(:current_user) { nil }
    it 'should not list content selection button' do
      expect(rendered).to_not have_tag('.search-scope')
    end
  end
end