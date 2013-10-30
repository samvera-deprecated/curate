shared_examples 'remotely_identified' do |remote_service_name|
  context "by #{remote_service_name}" do
    subject { FactoryGirl.create(described_class.name.underscore, attributes) }
    after(:each) {
      subject.destroy
    }
    context 'with valid attributes' do
      let(:attributes) { { publisher: 'An Interesting Chap!' } }
      it 'mints!' do
        expect {
          Hydra::RemoteIdentifier.mint(remote_service_name, subject)
        }.to change(subject, :identifier).from(nil)
      end
    end
    if remote_service_name == :doi
      context 'with invalid attributes' do
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
