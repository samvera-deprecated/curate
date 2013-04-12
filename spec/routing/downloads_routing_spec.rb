require 'spec_helper'

describe 'downloads routing' do
  let(:noid) { '1a2b3c' }

  it "routes GET /downloads/:id" do
    expect(
      get: "/downloads/#{noid}"
    ).to(
      route_to(
        controller: "downloads",
        action: "show",
        id: noid
      )
    )
  end
end
