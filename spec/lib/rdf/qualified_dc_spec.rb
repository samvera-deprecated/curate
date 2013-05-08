require 'spec_helper'

describe RDF::QualifiedDC do
  subject { RDF::QualifiedDC }
  let(:contributor_advisor_property) { subject.send("contributor#advisor") }
  it 'has "contributor#advisor" property' do
    expect(contributor_advisor_property).to be_kind_of(RDF::URI)
  end
end