FactoryGirl.define do
  factory :etd do
    ignore do
      user {FactoryGirl.create(:user)}
    end
    sequence(:title) {|n| "Title #{n}"}
    sequence(:abstract) {|n| "Abstract #{n}"}
    rights { Sufia.config.cc_licenses.keys.first }
    date_uploaded { Date.today }
    date_modified { Date.today }
    visibility Sufia::Models::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    subject "Emerald Ash Borer"
    country "United States of America"
    advisor "Karin Verschoor"
    creator "Franklin Wright"


    before(:create) { |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
      work.creator = evaluator.user.to_s
    }

    factory :private_etd do
      visibility Sufia::Models::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
    factory :public_etd do
      visibility Sufia::Models::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end
end
