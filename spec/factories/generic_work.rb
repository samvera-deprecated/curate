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
      work.set_visibility(evaluator.visibility)
    }
  end
end
