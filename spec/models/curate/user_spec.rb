require 'spec_helper'

describe User do

  describe "proxy_deposit_rights" do
    subject { FactoryGirl.build :user }
    let(:user1) { FactoryGirl.create :user }
    let(:user2) { FactoryGirl.create :user }
    before do
      subject.can_receive_deposits_from << user1
      subject.can_make_deposits_for << user2
      subject.save!
    end
    it "can_receive_deposits_from" do
      subject.can_receive_deposits_from.should == [user1]
      user1.can_make_deposits_for.should == [subject]
    end
    it "can_make_deposits_for" do
      subject.can_make_deposits_for.should == [user2]
      user2.can_receive_deposits_from.should == [subject]
    end
  end

end
