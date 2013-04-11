require 'spec_helper'

describe CommonObjectsController do

  let(:user) { FactoryGirl.create(:user) }

  describe 'devise sign_in helper' do
    it 'should set :current_user on signin' do
      expect {
        sign_in(user)
      }.to change(controller, :current_user).from(nil).to(user)
    end

    it 'should indicate :user_signed_in?' do
      expect {
        sign_in(user)
      }.to change(controller, :user_signed_in?).from(false).to(true)
    end
  end

  describe 'devise sign_out helper' do
    before(:each) do
      sign_in(user)
    end
    it 'should unset :current_user' do
      expect {
        sign_out(user)
      }.to change(controller, :current_user).from(user).to(nil)
    end

    it 'should indicate :user_signed_in?' do
      expect {
        sign_out(user)
      }.to change(controller, :user_signed_in?).from(true).to(false)
    end

  end
end
