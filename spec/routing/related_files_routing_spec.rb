require 'spec_helper'

describe 'related files routing' do
  let(:parent_id) { '1a2b3c' }
  let(:child_id) { '1a2b3c4d5e' }

  it "routes GET /concern/:parent_curation_concern_id/related_files" do
    expect(
      get: "/concern/#{parent_id}/related_files"
    ).to(
      route_to(
        controller: "curation_concern/related_files",
        action: "index",
        parent_curation_concern_id: parent_id
      )
    )
  end

  it "routes GET /concern/:parent_curation_concern_id/related_files/new" do
    expect(
      get: "/concern/#{parent_id}/related_files/new"
    ).to(
      route_to(
        controller: "curation_concern/related_files",
        action: "new",
        parent_curation_concern_id: parent_id
      )
    )
  end

  it "routes POST /concern/:parent_curation_concern_id/related_files" do
    expect(
      post: "/concern/#{parent_id}/related_files"
    ).to(
      route_to(
        controller: "curation_concern/related_files",
        action: "create",
        parent_curation_concern_id: parent_id
      )
    )
  end

  it "routes GET /concern/:parent_curation_concern_id/related_files/:id" do
    expect(
      get: "/concern/#{parent_id}/related_files/#{child_id}"
    ).to(
      route_to(
        controller: "curation_concern/related_files",
        action: "show",
        parent_curation_concern_id: parent_id,
        id: child_id
      )
    )
  end

  it "routes GET /concern/:parent_curation_concern_id/related_files/:id/edit" do
    expect(
      get: "/concern/#{parent_id}/related_files/#{child_id}/edit"
    ).to(
      route_to(
        controller: "curation_concern/related_files",
        action: "edit",
        parent_curation_concern_id: parent_id,
        id: child_id
      )
    )
  end

  it "routes PUT /concern/:parent_curation_concern_id/related_files/:id" do
    expect(
      put: "/concern/#{parent_id}/related_files/#{child_id}"
    ).to(
      route_to(
        controller: "curation_concern/related_files",
        action: "update",
        parent_curation_concern_id: parent_id,
        id: child_id
      )
    )
  end

  it "routes DELETE /concern/:parent_curation_concern_id/related_files/:id" do
    expect(
      delete: "/concern/#{parent_id}/related_files/#{child_id}"
    ).to(
      route_to(
        controller: "curation_concern/related_files",
        action: "destroy",
        parent_curation_concern_id: parent_id,
        id: child_id
      )
    )
  end

end
