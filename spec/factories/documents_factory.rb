FactoryGirl.define do
  factory :document, parent: :generic_work, class: Document do
    type { Document.valid_types.sample }

    factory :private_document do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end

    factory :public_document do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end
end
