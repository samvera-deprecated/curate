require 'spec_helper'

describe CurationConcern::DatasetsController do
  it_behaves_like 'is_a_curation_concern_controller', Dataset, actions: :all
end
