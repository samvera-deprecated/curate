FactoryGirl.define do
  factory :article do
    ignore do
      user {FactoryGirl.create(:user)}
    end
    sequence(:title) {|n| "Title #{n}"}
    sequence(:abstract) {|n| "Abstract #{n}"}
    rights { Sufia.config.cc_licenses.keys.first.dup }
    date_uploaded { Date.today }
    date_modified { Date.today }
    creator { ["Some Body"] }
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED

    before(:create) { |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    }

    factory :private_article do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
    factory :public_article do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end
end
