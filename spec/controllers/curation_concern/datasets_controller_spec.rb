require 'spec_helper'

describe CurationConcern::DatasetsController do
  include_examples 'is_a_curation_concern_controller', Dataset, actions: :all
end
