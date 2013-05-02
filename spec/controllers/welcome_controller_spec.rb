require 'spec_helper'

describe WelcomeController do

  let(:user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }

  describe '#index' do
    it 'should get a page' do
      get :index
      response.status.should == 200
    end
  end

  describe '#new' do
    it 'should redirect to classify_concern if logged in first time' do
      user.sign_in_count = 0
      user.save!
      sign_in user
      get :new
      response.should redirect_to(new_classify_concern_path)
    end

    it 'should redirect to dashboard_index for subsequent logins' do
      another_user.sign_in_count = 2
      another_user.save!
      sign_in another_user
      get :new
      response.should redirect_to(dashboard_index_path)
    end
  end
end
