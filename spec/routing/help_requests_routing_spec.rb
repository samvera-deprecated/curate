require 'spec_helper'

describe 'help requests routing' do

  it "routes GET /help_requests/new" do
    expect(
      get: "/help_requests/new"
    ).to route_to(controller: "help_requests", action: "new")
  end

end
