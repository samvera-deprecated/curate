FactoryGirl.define do
  factory :generic_work do
    sequence(:title) {|n| "Title #{n}"}
    rights { Sufia.config.cc_licenses.keys.first }
  end
end
