require 'spec_helper'

describe 'classify routing' do
  it "routes GET /classify" do
    expect(
      get: "/classify"
    ).to route_to(controller: "classify",action: "new")
  end

  it "routes POST /classify" do
    expect(
      post: "/classify"
    ).to route_to(controller: "classify", action: "create")
  end
end
