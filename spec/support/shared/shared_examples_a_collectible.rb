shared_examples 'a_collectible' do
  context 'behavior' do
    subject { described_class }
    it 'implements the Collectible interface' do
      expect(described_class.included_modules).to include(Hydra::Collections::Collectible)
    end
  end
end
