FactoryGirl.define do
  factory :etd do
    ignore do
      person {FactoryGirl.create(:person_with_user)}
    end
    sequence(:title) {|n| "Title #{n}"}
    sequence(:abstract) {|n| "Abstract #{n}"}
    rights { Sufia.config.cc_licenses.keys.first }
    date_uploaded { Date.today }
    date_modified { Date.today }
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    subject "Emerald Ash Borer"
    country "United States of America"
    advisor "Karin Verschoor"


    before(:create) { |work, evaluator|
      work.apply_depositor_metadata(evaluator.person.user.user_key)
      work.creators << evaluator.person
    }

    factory :private_etd do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
    factory :public_etd do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end
end
