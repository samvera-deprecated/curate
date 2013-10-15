require 'spec_helper'

describe '/purl routing' do
  # Some implementers of Curate may be making the guarantee that this URL
  # is permanently addressable via a remote identifier (i.e. DOI, ARK)
  # So as not to raise the ire of both librarians and developers, don't
  # remove this spec nor the URL!
  it "routes GET /show/:id" do
    param_id = "12a34b56c"
    expect(get: "/show/#{param_id}").to(
      route_to(controller: "common_objects", action: "show", id: param_id)
    )
  end
end
