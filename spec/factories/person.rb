FactoryGirl.define do
  factory :person do
    sequence(:name) {|n| "Person #{n}" }
  end
end
