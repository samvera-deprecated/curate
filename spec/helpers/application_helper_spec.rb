require 'spec_helper'

describe ApplicationHelper do
  it 'has #sufia as a "monkey-patch" for sufia gem' do
    expect(helper.sufia).to eq(helper)
  end

  describe '#bootstrap_navigation_element' do
    let(:path) { '/hello/world' }
    let(:name) { "Link Name"}
    it 'disables the navigation link to the active page' do
      helper.should_receive(:current_page?).with(path).and_return(true)
      expect(helper.bootstrap_navigation_element(name, path)).
        to have_tag('li.disabled a')
    end
    it 'does not disable a navigation link that is not the active page' do
      helper.should_receive(:current_page?).with(path).and_return(false)
      expect(helper.bootstrap_navigation_element(name, path)).
        to_not have_tag('li.disabled a')
    end
  end
end
