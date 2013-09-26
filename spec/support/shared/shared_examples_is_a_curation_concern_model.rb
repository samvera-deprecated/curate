shared_examples 'is_a_curation_concern_model' do 
  CurationConcern::FactoryHelpers.load_factories_for(self, described_class)

  it 'is registered for classification' do
    expect(Curate.configuration.registered_curation_concern_types).to include(described_class.name)
  end

  it { should have_unique_field(:resource_type) }

  describe 'its test support factories', factory_verification: true do
    it {
      expect {
        FactoryGirl.create(default_work_factory_name).destroy
      }.to_not raise_error
    }
    it {
      expect {
        FactoryGirl.create(private_work_factory_name).destroy
      }.to_not raise_error
    }
    it {
      expect {
        FactoryGirl.create(public_work_factory_name).destroy
      }.to_not raise_error
    }
    it {
      expect {
        FactoryGirl.create(default_work_factory_name).destroy
      }.to_not raise_error
    }
  end

end
