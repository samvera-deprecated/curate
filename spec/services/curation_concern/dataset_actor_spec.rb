require 'spec_helper'

describe CurationConcern::DatasetActor do
  include_examples 'is_a_curation_concern_actor', Dataset
end
