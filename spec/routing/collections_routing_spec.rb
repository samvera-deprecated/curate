require 'spec_helper'

describe 'Routes for Collections: ' do

  it 'Route to display form for adding item to a collection' do
    expect( get('collections/add_member_form') ).to(
      route_to(controller: 'curate/collections',
               action: 'add_member_form')
    )
  end

  it 'Route to add item to a collection' do
    expect( put('collections/add_member') ).to(
      route_to(controller: 'curate/collections',
               action: 'add_member')
    )
  end

end
