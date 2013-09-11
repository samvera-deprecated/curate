require 'spec_helper'

describe Curate::Service::UserCreateCallback do
  let(:user) { FactoryGirl.create(:user) }
  subject { Curate::Service::UserCreateCallback.new(user) }

  it {
    expect{
      subject.call
    }.to change{ user.person.persisted? }.from(false).to(true)
  }

end
