require 'spec_helper'
shared_examples 'with_access_rights' do

  it "has an under_embargo?" do
    expect {
      subject.under_embargo?
    }.to_not raise_error(NoMethodError)
  end

  it "has a visibility attribute" do
    expect(subject).to respond_to(:visibility)
    expect(subject).to respond_to(:visibility=)
  end

  it "has an open_access?" do
    expect {
      subject.open_access?
    }.to_not raise_error(NoMethodError)
  end

  it "has an authenticated_only_access?" do
    expect {
      subject.authenticated_only_access?
    }.to_not raise_error(NoMethodError)
  end

  it "has an private_access?" do
    expect {
      subject.private_access?
    }.to_not raise_error(NoMethodError)
  end

end
