FactoryGirl.define do
  factory :senior_thesis, class: 'SeniorThesis' do
    sequence(:title) {|n| "Title #{n}"}
    rights { Sufia::Engine.config.cc_licenses.keys.first }
    sequence(:creator) {|n|["Creator Name#{n}"]}
    description 'Hello World!'
  end
  factory :senior_thesis_invalid, class: 'SeniorThesis' do
    title ''
  end
end
