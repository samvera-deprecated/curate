require 'spec_helper'

describe User do
  it 'should have #agreed_to_terms_of_service?' do
    User.new.should respond_to(:agreed_to_terms_of_service?)
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
