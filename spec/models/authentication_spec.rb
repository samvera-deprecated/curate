require 'spec_helper'

describe Authentication do
  describe '#find_by_provider_and_uid' do
    let(:cas_auth) { FactoryGirl.create(:authentication_with_cas) }
    let(:user) { cas_auth.user }

    it 'should return nil' do
      expect(Authentication.find_by_provider_and_uid('twitter', cas_auth.uid)).to eq(nil)
    end

    it 'should return appropriate results' do
      expect(Authentication.find_by_provider_and_uid('cas', cas_auth.uid)).to eq(cas_auth)
    end
  end
end
