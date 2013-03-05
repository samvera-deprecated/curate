require 'spec_helper'

describe ClassifyController do
  render_views

  describe '#new' do
    let(:user) { FactoryGirl.create(:user) }
    it 'requires authentication' do
      get :new
      response.status.should == 302
      expect(response).to redirect_to(user_session_path)
    end
    it 'renders when signed in' do
      sign_in(user)
      get :new
      response.status.should == 200
    end
  end

  describe '#create' do
    let(:user) { FactoryGirl.create(:user) }
    it 'requires authentication' do
      post :create, classify: { concern: 'SeniorThesis' }
      response.status.should == 302
      expect(response).to redirect_to(user_session_path)
    end

    it 'requires authentication' do
      post :create, classify: { concern: 'SeniorThesis' }
      response.status.should == 302
      expect(response).to redirect_to(user_session_path)
    end

  end
end
