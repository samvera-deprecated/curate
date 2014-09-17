require 'spec_helper'

describe DoiMintingWorker do
  let(:generic_work) { GenericWork.new(attributes)  }
  let(:attributes) do {
      pid: "#{Sufia.config.id_namespace}:3t94g081v",
      publisher: 'An Interesting Chap!',
      date_uploaded: Date.parse('2013-01-30'),
      date_modified: Date.parse('2013-01-30'),
      title: "A Title", creator: 'The Creator'
    }
  end

  it 'should raise error when no pid' do
    expect{
      DoiMintingWorker.new(nil)
    }.to raise_error( DoiMintingWorker::PidError )
  end

  context 'mint doi' do
    it "should mint!", VCR::SpecSupport(record: :none, cassette_name: "remotely_identified_doi_mint_generic_work") do
      allow(ActiveFedora::Base).to receive(:find).with(attributes[:pid], kind_of(Hash)).and_return(generic_work)
      allow(generic_work).to receive(:save)
      expect{
        DoiMintingWorker.new(attributes[:pid]).run
      }.to change(generic_work, :identifier).from(nil)
    end
  end

end
