require 'spec_helper'

describe CurationConcern::SeniorThesesController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  describe '#new' do
    it 'should be successful' do
      get :new
      controller.senior_thesis.should be_kind_of(SeniorThesis)
      response.should be_successful
    end
  end
  describe '#create' do
  end
  describe '#show' do
  end
  describe '#edit' do
  end
  describe '#update' do
  end
  describe '#destroy' do
  end
end
