require 'spec_helper'

describe User do

  it 'should set agree to terms of service' do
    user = FactoryGirl.create(:user, agreed_to_terms_of_service: false)
    user.agreed_to_terms_of_service?.should == false
    user.agree_to_terms_of_service!
    user.agreed_to_terms_of_service?.should == true
  end

  it 'has a #to_s that is #username' do
    User.new(username: 'hello').to_s.should == 'hello'
  end

  describe '#update_with_password' do
    let(:user) { FactoryGirl.create(:user) }
    let(:email) { 'hello@world.com' }
    it 'should update email, if given' do
      expect {
        user.update_with_password(email: email)
      }.to change(user, :email).from('').to(email)
    end
  end

  describe '.batchuser' do
    it 'persists an instance the first time, then returns the persisted object' do
      expect {
        User.batchuser
      }.to change { User.count }.by(1)

      expect {
        User.batchuser
      }.to change { User.count }.by(0)
    end
  end

  describe '.audituser' do
    it 'persists an instance the first time, then returns the persisted object' do
      expect {
        User.audituser
      }.to change { User.count }.by(1)

      expect {
        User.audituser
      }.to change { User.count }.by(0)
    end
  end
end
