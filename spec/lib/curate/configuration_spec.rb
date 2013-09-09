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
  end
end
