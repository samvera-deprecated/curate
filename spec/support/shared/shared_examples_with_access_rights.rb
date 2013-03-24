require 'spec_helper'
shared_examples 'with_access_rights' do

  it "has a visibility attribute" do
    expect(subject).to respond_to(:visibility)
    expect(subject).to respond_to(:visibility=)
  end

  it "has an open_access_rights?" do
    expect {
      subject.open_access_rights?
    }.to_not raise_error(NoMethodError)
  end

  it "has an authenticated_only_rights?" do
    expect {
      subject.authenticated_only_rights?
    }.to_not raise_error(NoMethodError)
  end

  it "has an private_rights?" do
    expect {
      subject.private_rights?
    }.to_not raise_error(NoMethodError)
  end

end
