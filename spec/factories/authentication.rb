FactoryGirl.define do
  factory :authentication do
    sequence(:id) {|n| n }
    before(:create) {|obj|
      user = FactoryGirl.create(:user)
      obj.apply_depositor_metadata(user.user_key)
    }
  end
  factory :authentication_with_cas, class: Authentication do
    initialize_with {
      user = FactoryGirl.build(:user)
      user.stub(:id).and_return(1234)
      authentication = user.authentications.build(provider: 'cas',
          uid: "k1234",
          user_id: user.id,
          token: '',
          token_secret: '')
      authentication.save
      authentication
    }
  end
end
