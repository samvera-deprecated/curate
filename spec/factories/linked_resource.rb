FactoryGirl.define do
  factory :linked_resource do
    association :batch, factory: :generic_work
  end
end

