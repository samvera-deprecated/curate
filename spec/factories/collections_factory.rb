FactoryGirl.define do
  factory :collection do
    ignore do
      user {FactoryGirl.create(:user)}
    end
    sequence(:title) {|n| "Title #{n}"}
    before(:create) { |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    }
  end

  factory :public_collection, class: :collection do
    sequence(:title) {|n| "Title #{n}"}
    before(:create) { |work, evaluator|
      work.apply_depositor_metadata(FactoryGirl.create(:user).user_key)
      work.read_groups = ['public']
    }
  end
end

