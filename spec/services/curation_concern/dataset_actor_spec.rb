require 'spec_helper'

describe CurationConcern::DatasetActor do
  it_behaves_like 'is_a_curation_concern_actor', Dataset
end
