require 'spec_helper'

describe Profile do
  subject { Profile.new }
  it 'can never be part of a collection' do
    expect {
      subject.can_be_member_of_collection?
    }.to raise_error(NoMethodError)
  end

  it_behaves_like 'a_collection_like_object'

end
