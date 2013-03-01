require 'spec_helper'

describe 'generic files routing' do
  let(:parent_type) { 'senior_thesis' }
  let(:parent_id) { '1a2b3c' }
  let(:child_id) { '1a2b3c4d5e' }

  it "routes GET /concern/related_files/:id" do
    expect(
      get: "/concern/generic_files/#{child_id}"
    ).to(
      route_to(
        controller: "curation_concern/generic_files",
        action: "show",
        id: child_id
      )
    )
  end

  it "routes GET /concern/related_files/:id/edit" do
    expect(
      get: "/concern/generic_files/#{child_id}/edit"
    ).to(
      route_to(
        controller: "curation_concern/generic_files",
        action: "edit",
        id: child_id
      )
    )
  end

  it "routes GET /concern/related_files/:id" do
    expect(
      put: "/concern/generic_files/#{child_id}"
    ).to(
      route_to(
        controller: "curation_concern/generic_files",
        action: "update",
        id: child_id
      )
    )
  end

  it "routes GET /concern/:parent_type/:parent_id/related_files/new" do
    expect(
      get: "/concern/#{parent_type}/#{parent_id}/generic_files/new"
    ).to(
      route_to(
        controller: "curation_concern/generic_files",
        action: "new",
        parent_id: parent_id,
        parent_type: parent_type,
      )
    )
  end

  it "routes POST /concern/:parent_type/:parent_id/related_files" do
    expect(
      post: "/concern/#{parent_type}/#{parent_id}/generic_files"
    ).to(
      route_to(
        controller: "curation_concern/generic_files",
        action: "create",
        parent_id: parent_id,
        parent_type: parent_type,
      )
    )
  end

end
