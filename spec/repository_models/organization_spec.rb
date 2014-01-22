require 'spec_helper'

describe Organization do
  let(:organization) { Organization.new}
  let(:person) { FactoryGirl.create(:person)}


  it 'should do something' do
    organization.add_member(person)
    expect { organization.members }.to include(person)
  end
end
