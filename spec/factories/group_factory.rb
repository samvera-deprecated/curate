FactoryGirl.define do
  factory :group, class: Hydramata::Group do
    ignore do 
      user {FactoryGirl.create(:user)} 
    end 
    title {|n| "Title #{n}"}
    description {|n| "Description text for #{n}"}
    date_uploaded { Date.today }
    date_modified { Date.today }

    factory :public_group do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end

    factory :private_group do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
  end

end
