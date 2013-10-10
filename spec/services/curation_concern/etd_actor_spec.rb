require 'spec_helper'

describe CurationConcern::EtdActor do
  # Can't include this spec because ETD doesn't have linked_resources
  #include_examples 'is_a_curation_concern_actor', Etd
  let(:etd) { Etd.new }
  let(:user) { FactoryGirl.create(:user) }
  subject { CurationConcern.actor(etd, user, attributes) }

  describe '#create' do
    let(:attributes) do
      {
        "title"=>"My Etd Title", "alternate_title"=>"", "abstract"=>"Fooba", 
        "creators_attributes"=>{"0"=>{"id"=>"", "name"=>"Buddy"}, "1"=>{"id"=>"", "name"=>"Jimmy"}}, 
        "subject"=>["Stuff"], "country"=>"USA", "advisor"=>["Frank"], "language"=>["English", ""], 
        "contributor"=>[""], "contributor_role"=>[""], "publisher"=>[""], "coverage_temporal"=>[""], 
        "coverage_spatial"=>[""], 
        "date_created(1i)"=>"2013", "date_created(2i)"=>"10", "date_created(3i)"=>"9", 
        "note"=>"", "embargo_release_date"=>"", "visibility"=>"restricted", "rights"=>"All rights reserved"
      }
    end
    before do
      subject.create!
    end

    it "should have set multiple creators" do
      expect(etd).to be_persisted
      reloaded = Etd.find(etd.pid)
      expect(reloaded.creators.size).to eq 2
      expect(reloaded.creators.map(&:name)).to eq ['Buddy', 'Jimmy']
    end
    
  end

end
