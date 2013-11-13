shared_examples 'a_collection_like_object' do
  context 'behavior' do
    subject { described_class }
    it 'implements the CollectionModel interface' do
      expect(described_class.included_modules).to include(CurationConcern::CollectionModel)
    end
  end
end
