require 'spec_helper'

describe ContributorAgreement do
  subject { ContributorAgreement.new(curation_concern, user) }
  let(:curation_concern) { SeniorThesis.new }
  let(:user) { User.new }

  it 'has human readable text' do
    subject.human_readable_text.should be_kind_of(String)
  end

  it 'has legally binding text' do
    subject.legally_binding_text.should be_kind_of(String)
  end

end