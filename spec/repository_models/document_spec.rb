require 'spec_helper'

describe Document do
  subject {  FactoryGirl.build(:document) }

  it { should have_unique_field(:title) }
  it { should have_unique_field(:type) }
  it { should have_unique_field(:genre) }


  it_behaves_like 'is_a_curation_concern_model'
  it_behaves_like 'with_related_works'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'has_common_solr_fields'

  describe 'valid types: ' do
    let(:doc) { FactoryGirl.build(:document) }

    Document.valid_types.each do |type|
      it "type '#{type}' is valid" do
        doc.type = type
        doc.valid?
        expect(doc.errors[:type]).to_not be_present
      end
    end

    it 'non-whitelist genre are not valid' do
      doc.genre = 'Invalid document genre'
      doc.valid?
      expect(doc.errors[:genre]).to be_present
    end

    it 'type can be nil' do
      doc.type = nil
      expect(doc.errors[:type]).to_not be_present
    end
  end

end

describe Document do
  subject { Document.new }

  it_behaves_like 'with_access_rights'

end
