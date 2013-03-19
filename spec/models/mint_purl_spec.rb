require 'spec_helper'

# https://github.com/bblimke/webmock
require 'webmock/rspec'

describe MintPurl do

  subject { MintPurl.new(fedora_object) }
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

  let(:expected_purl_link) { "http://localhost:3000/view/1/#{noid}" }

  it 'requires a fedora object that is present and responds to_param' do
    expect { MintPurl.new(bad_fedora_object) }.to raise_error(ArgumentError)
  end

  describe 'create_or_retreive_purl' do
    it 'should return purl link' do
      subject.create_or_retreive_purl.should == expected_purl_link
    end
  end

end
