require 'spec_helper'

describe HelpRequest do
  subject { HelpRequest.new(attributes) }
  let(:user) { FactoryGirl.create(:user) }
  let(:attributes) { FactoryGirl.attributes_for(:help_request) }

  describe 'with how_can_we_help_you: nil' do
    let(:attributes) { FactoryGirl.attributes_for(:help_request_invalid) }
    it { should_not be_valid}
  end


  describe 'return valid attributes' do

    it 'return valid user email and user key' do
      subject.user=user
      subject.sender_email.should == user.email
      subject.user_name.should == user.user_key
    end

    it 'return curate help email and unknown' do
      subject.sender_email.should == 'help@curate.org'
      subject.user_name.should == 'Unknown'
    end

  end

end
