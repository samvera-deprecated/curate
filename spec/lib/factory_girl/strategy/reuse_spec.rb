require 'spec_helper'

describe FactoryGirl::Strategy::Reuse do
  it 'should reuse objects' do
    user_1 = FactoryGirl.reuse(:user)
    expect(user_1).to eq FactoryGirl.reuse(:user)
  end

  it 'should reuse objects that were already created' do
    user_1 = FactoryGirl.create(:user)
    expect(user_1).to_not eq FactoryGirl.reuse(:user)
  end
end
