require 'spec_helper'

describe ErrorsController do
  it 'GET #not_found' do
    get :not_found
    expect(response).to render_template('not_found')
  end
  it 'PUT #not_found' do
    put :not_found
    expect(response).to render_template('not_found')
  end
  it 'DELETE #not_found' do
    delete :not_found
    expect(response).to render_template('not_found')
  end
  it 'POST #not_found' do
    post :not_found
    expect(response).to render_template('not_found')
  end
end