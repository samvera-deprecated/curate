shared_examples 'remotely_identified' do |remote_service_name|
  context "by #{remote_service_name}" do
    context 'with valid attributes' do
      subject { FactoryGirl.create(described_class.name.underscore, attributes) }
      let(:attributes) { { publisher: 'An Interesting Chap!' } }

      it 'mints!', VCR::SpecSupport(cassette_name: "remotely_identified_#{remote_service_name}_mint_#{described_class.name.underscore}") do
        expect {
          Hydra::RemoteIdentifier.mint(remote_service_name, subject)
        }.to change(subject, :identifier).from(nil)
      end
    end
    if remote_service_name == :doi
      context 'with invalid attributes' do
        subject { FactoryGirl.build(described_class.name.underscore, attributes: attributes) }
        let(:attributes) { { publisher: [] } }
        it 'fails validation' do
          subject.should_receive(:remote_doi_assignment_strategy?).and_return(true)
          expect(subject).to_not be_valid
          expect(subject.errors[:publisher]).to eq(["is required for remote DOI minting"])
        end
      end
    end
  end
end
