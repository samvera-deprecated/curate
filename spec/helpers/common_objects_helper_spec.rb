require 'spec_helper'

describe CommonObjectsHelper do
  let(:curation_concern) { GenericFile.new }
  it 'has #common_object_partial_for' do
    expect(helper.common_object_partial_for(GenericFile.new)).to eq("common_objects/generic_file")
  end

end
