require 'spec_helper'

describe ContributorAgreement do
  subject { ContributorAgreement.new(curation_concern, user, params) }
  let(:curation_concern) { GenericWork.new }
  let(:user) { User.new }
  let(:params) { {} }


  it 'has acceptance value' do
    subject.acceptance_value.should == 'accept'
  end

  it 'has param key' do
    subject.param_key.should == :accept_contributor_agreement
  end

  describe 'without acceptance' do
    let(:params) { {} }

    it 'has param value' do
      subject.param_value.should == nil
    end

    it 'is most definitely not being accepted' do
      subject.is_being_accepted?.should == false
    end
  end

  describe 'with acceptance' do
    let(:params) { {accept_contributor_agreement: 'accept'} }

    it 'has a param value of "accept"' do
      subject.param_value.should == 'accept'
    end

    it 'is in the process of being accepted' do
      subject.is_being_accepted?.should == true
    end
  end
end
