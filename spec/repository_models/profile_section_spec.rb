require 'spec_helper'

describe ProfileSection do

  it_behaves_like 'a_collectible'
  it_behaves_like 'a_collection_like_object'


  it 'can be a member of a Profile' do
    expect( subject.can_be_member_of_collection?(Profile.new) ).to eq true
  end

  it 'cannot be a member of a Collection' do
    expect( subject.can_be_member_of_collection?(Collection.new) ).to eq false
  end

end