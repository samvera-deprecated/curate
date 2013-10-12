require 'spec_helper'

describe CurationConcern::DocumentActor do
  it_behaves_like 'is_a_curation_concern_actor', Document
end
