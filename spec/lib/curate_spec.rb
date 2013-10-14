require 'spec_helper'

describe Curate do
  let(:curation_concern) { double(noid: "abc123") }

  context '.permanent_url' do
    it {
      expect(Curate.permanent_url_for(curation_concern)).to eq(File.join(Curate.configuration.application_root_url, "/show/#{curation_concern.noid}"))
    }
  end

end