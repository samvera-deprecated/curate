# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :help_request do
    how_can_we_help_you "It's on fire"
  end
  factory :help_request_invalid, parent: :help_request do
    how_can_we_help_you ""
  end
end
