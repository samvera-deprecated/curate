require 'spec_helper'

describe CurationConcern::EtdsController do
  it_behaves_like 'is_a_curation_concern_controller', Etd, actions: :all
end
