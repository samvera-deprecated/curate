require 'spec_helper'

describe Document do
  subject {  FactoryGirl.build(:document) }

  it 'factory creates a valid document' do
    doc = FactoryGirl.build(:document)
    doc.class.should == Document
    doc.valid?.should be_true
  end

  it { should have_unique_field(:title) }
  it { should have_unique_field(:type) }

  it_behaves_like 'is_a_curation_concern_model'
  it_behaves_like 'with_access_rights'
  it_behaves_like 'with_related_works'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'has_dc_metadata'
  it_behaves_like 'has_common_solr_fields'

  describe 'valid types: ' do
    let(:doc) { FactoryGirl.build(:document) }

    Document.valid_types.each do |type|
      it "type '#{type}' is valid" do
        doc.type = type
        doc.valid?.should be_true
      end
    end

    it 'non-whitelist types are not valid' do
      doc.type = 'Invalid document type'
      doc.valid?.should be_false
    end

    it 'type can be nil' do
      doc.type = nil
      doc.valid?.should be_true
    end
  end

end
