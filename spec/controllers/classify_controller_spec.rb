require 'spec_helper'

describe ClassifyController do
  render_views

  describe '#index' do
    it 'requires authentication' do
      get :index
      response.status.should == 302
      expect(response).to redirect_to(user_session_path)
    end
    it 'renders when signed in' do
      user = FactoryGirl.create(:user)
      sign_in(user)
      get :index
      response.status.should == 200
    end
  end
end
