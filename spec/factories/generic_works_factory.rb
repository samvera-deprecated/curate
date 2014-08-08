FactoryGirl.define do
  factory :generic_work do
    ignore do
      user {FactoryGirl.create(:user)}
    end
    sequence(:title) {|n| "Title #{n}"}
    rights { Sufia.config.cc_licenses.keys.first.dup }
    date_uploaded { Date.today }
    date_modified { Date.today }
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    before(:create) { |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
      work.owner = evaluator.user.user_key
      work.contributor << "Some Body"
      work.creator << "The Creator"
    }

    factory :private_generic_work do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
    factory :public_generic_work do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
    factory :generic_work_with_files do
      ignore do
        file_count 3
      end

      after(:create) do |work, evaluator|
        FactoryGirl.create_list(:generic_file, evaluator.file_count, batch: work, user: evaluator.user)
      end
    end
  end
end
