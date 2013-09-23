FactoryGirl.define do
  factory :person do
    sequence(:name) {|n| "Person #{n}" }
    before(:create) {|obj|
      user = FactoryGirl.create(:user)
      obj.apply_depositor_metadata(user.user_key)
    }
  end
  factory :person_with_user, class: Person do
    initialize_with {
      user = FactoryGirl.create(:user)
      user.person
    }
  end
end
