require 'spec_helper'

describe CurationConcern::Work do
  context '.ids_from_tokens' do
    it 'splits tokens on commas' do
      expect(described_class.ids_from_tokens("ab , cd ")).to eq(['ab', 'cd'])
    end
  end
end
