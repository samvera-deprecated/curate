require 'spec_helper'

require 'casclient'
require 'casclient/frameworks/rails/filter'

describe_options = {type: :feature}
if ENV['JAVASCRIPT']
  describe_options[:js] = true
end

describe 'error behavior', describe_options do
  it 'should render 404' do
    visit('/apollo')
    expect(page).to have_content('The page you are looking for may have been removed, had its name changed, or is temporarily unavailable.')
  end
end