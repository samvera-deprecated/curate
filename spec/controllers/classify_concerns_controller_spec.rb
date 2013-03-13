require 'spec_helper'

describe ClassifyConcernsController do
  render_views
  let(:user) { FactoryGirl.create(:user) }

  describe '#new' do
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
    it 'redirect to login page if user is not logged in' do
      post :create, classify: { curation_concern_type: 'SeniorThesis' }
      response.status.should == 302
      expect(response).to redirect_to(user_session_path)
    end

    it 'requires authentication' do
      sign_in(user)
      post :create, classify_concern: { curation_concern_type: 'SeniorThesis' }
      response.status.should == 302
      expect(response).to redirect_to(new_curation_concern_senior_thesis_path)
    end

  end
end
