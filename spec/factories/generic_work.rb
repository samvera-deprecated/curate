FactoryGirl.define do
  factory :generic_work do
    ignore do
      user {FactoryGirl.create(:user)}
      visibility AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    end
    sequence(:title) {|n| "Title #{n}"}
    rights { Sufia.config.cc_licenses.keys.first }
    date_uploaded { Date.today }
    date_modified { Date.today }
    before(:create) { |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
      work.creator = evaluator.user.to_s
      work.visibility = evaluator.visibility
    }

    factory :private_work do
      ignore do
        visibility AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
      end
    end
    factory :public_work do
      ignore do
        visibility AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      end
    end
  end
end
