require 'spec_helper'
shared_examples 'is_a_curation_concern_controller' do |collection_class|
  its(:curation_concern_type) { should eq collection_class }
end
