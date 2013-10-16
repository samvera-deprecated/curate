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

  it 'list depositors' do
    expect(
      get: "people/#{id}/depositors"
    ).to(
      route_to(controller: 'curate/depositors',
               action: 'index',
               person_id: id)
    )
  end

  it 'adds depositors' do
    expect(
      post: "people/#{id}/depositors"
    ).to(
      route_to(controller: 'curate/depositors',
               action: 'create',
               person_id: id)
    )
  end

  it 'removes depositors' do
    expect(
      delete: "people/#{id}/depositors/99"
    ).to(
      route_to(controller: 'curate/depositors',
               action: 'destroy',
               person_id: id,
               id: '99')
    )
  end
end
