require 'spec_helper'
require "ostruct"

describe RepoObject do
  let(:pid) { "TEST:#{noid}" }
  let(:noid) { '1234' }
  let(:bad_fedora_object) { nil }
  let(:create_date) { DateTime.new(2000,-11,-26,-20,-55,-54,'+7') }
  let(:date_added) { DateTime.new(2001,-11,-26,-20,-55,-54,'+7') }
  let(:modified_date) { DateTime.new(2002,-11,-26,-20,-55,-54,'+7') }

  let(:fedora_object) {
    double(
      'FedoraObject',
      to_param: noid,
      date_added: date_added,
      modified_date: modified_date,
      create_date: create_date
    )
  }

  describe ".create_repo_object" do
    let(:expected_url) { File.join(Rails.configuration.application_url, "show", fedora_object.to_param) }
    it 'should raise exception if no object given' do
      expect {
        RepoObject.create_from_fedora_object(nil)
      }.to raise_error(ArgumentError)
    end

    it 'should_create_data_in_purl_database' do
      RepoObject.create_from_fedora_object(fedora_object)
      results = RepoObject.where(:filename => fedora_object.to_param)
      object = results.first

      expect(object.filename).to eq(fedora_object.to_param)
      expect(object.url).to eq(expected_url)
    end
  end
end
