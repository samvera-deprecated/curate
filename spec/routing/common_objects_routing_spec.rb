require 'spec_helper'

describe '/purl routing' do
  it "routes GET /purl/:id" do
    param_id = "12a34b56c"
    expect(get: "/show/#{param_id}").to(
      route_to(controller: "common_objects", action: "show", id: param_id)
    )
  end
end
