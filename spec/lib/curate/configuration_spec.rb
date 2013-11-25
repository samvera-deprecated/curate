require 'spec_helper'

module Curate
  describe Configuration do
    its(:default_antivirus_instance) { should respond_to(:call)}
    its(:build_identifier) { should be_an_instance_of String }
    it 'allow for registration of curation_concerns' do
      expect {
        subject.register_curation_concern(:generic_work)
      }.to change{ subject.registered_curation_concern_types }.from([]).to(['GenericWork'])

    end

    it "has a list of the registered classes" do
      expect {
        subject.register_curation_concern(:generic_work)
        subject.register_curation_concern(:image)
      }.to change{ subject.curation_concerns }.from([]).to([GenericWork, Image])
    end

    context '#application_root_url' do
      around(:each) do |example|
        begin
          old_url = subject.application_root_url
          subject.application_root_url = nil
          example.run
        ensure
          subject.application_root_url = old_url
        end
        it 'should require application_root_url to be configured' do
          old_value = subject.application_root_url
          expect {
            subject.application_root_url
          }.to raise_error(RuntimeError)
        end
      end
    end
  end
end
