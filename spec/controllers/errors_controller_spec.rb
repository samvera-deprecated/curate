require 'spec_helper'

describe ErrorsController do
  describe '#not_found' do
    it 'GET' do
      get :not_found
      expect(response).to render_template('not_found')
      expect(response.status).to eq(404)
    end
    it 'PUT' do
      put :not_found
      expect(response).to render_template('not_found')
      expect(response.status).to eq(404)
    end
    it 'DELETE' do
      delete :not_found
      expect(response).to render_template('not_found')
      expect(response.status).to eq(404)
    end
    it 'POST' do
      post :not_found
      expect(response).to render_template('not_found')
      expect(response.status).to eq(404)
    end
  end
  describe '#unauthorized' do
    it 'GET' do
      get :unauthorized
      expect(response).to render_template('unauthorized')
      expect(response.status).to eq(401)
    end
    it 'PUT' do
      put :unauthorized
      expect(response).to render_template('unauthorized')
      expect(response.status).to eq(401)
    end
    it 'DELETE' do
      delete :unauthorized
      expect(response).to render_template('unauthorized')
      expect(response.status).to eq(401)
    end
    it 'POST' do
      post :unauthorized
      expect(response).to render_template('unauthorized')
      expect(response.status).to eq(401)
    end
  end
end
