require 'spec_helper'

describe HelpRequestsController do
  render_views
  describe 'GET #new' do
    let(:user) { FactoryGirl.create(:user) }
    it 'is disallowed when not logged in' do
      get(:new)
      expect(response.status).to eq(302)
      expect(response).to redirect_to(new_user_session_path)
    end
    it 'requires login' do
      sign_in(user)
      get(:new)
      expect(response.status).to eq(200)
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    let(:user) { FactoryGirl.create(:user) }
    let(:attributes) { {} }
    describe 'success' do
      let(:attributes) { FactoryGirl.attributes_for(:help_request) }
      it 'redirects to dashboard and flashes a message' do
        sign_in(user)
        post(:create, help_request: attributes)
        expect(response.status).to eq(302)
        expect(response).to redirect_to(dashboard_index_path)
      end
    end
    describe 'failure' do
      let(:attributes) { FactoryGirl.attributes_for(:help_request_invalid) }
      it 're-renders the form' do
        sign_in(user)
        post(:create, help_request: attributes)
        expect(response.status).to eq(200)
        expect(response).to render_template('new')
      end
    end
  end
end
