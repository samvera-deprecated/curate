shared_examples 'remotely_identified' do |remote_service_name|
  context "by #{remote_service_name}" do
    subject { FactoryGirl.create(described_class.name.underscore, publisher: 'An Interesting Chap!') }
    it 'mints!' do
      expect {
        Hydra::RemoteIdentifier.mint(remote_service_name, subject)
      }.to change(subject, :identifier).from(nil)
    end
    after(:each) {
      subject.destroy
    }
  end
end
