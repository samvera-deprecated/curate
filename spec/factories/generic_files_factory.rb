FactoryGirl.define do
  factory :generic_file do
    ignore do
      user {FactoryGirl.create(:user)}
    end
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    file "Sample file"
    batch { FactoryGirl.create(:generic_work, user: user) }
    before(:create) { |file, evaluator|
       file.apply_depositor_metadata(evaluator.user.user_key)
    }

    factory :private_generic_file do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
  end
end

