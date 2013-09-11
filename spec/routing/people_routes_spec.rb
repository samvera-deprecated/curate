require 'spec_helper'

describe 'people routes' do
  let(:id) { '123' }

  it 'shows a person' do
    expect(
      get: "people/#{id}"
    ).to(
      route_to(controller: 'curate/people',
               action: 'show',
               id: id)
    )
  end

end
