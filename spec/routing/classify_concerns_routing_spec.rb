require 'spec_helper'

describe 'classify_concerns routing' do
  it "routes GET /classify_concerns/new" do
    expect(
      get: "/classify_concerns/new"
    ).to route_to(controller: "classify_concerns",action: "new")
  end

  it "routes POST /classify_concerns" do
    expect(
      post: "/classify_concerns"
    ).to route_to(controller: "classify_concerns", action: "create")
  end
end
