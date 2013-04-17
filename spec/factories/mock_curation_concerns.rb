FactoryGirl.define do
  factory :mock_curation_concern do
    sequence(:title) {|n| "Title #{n}"}
    rights { Sufia::Engine.config.cc_licenses.keys.first }
  end
end
