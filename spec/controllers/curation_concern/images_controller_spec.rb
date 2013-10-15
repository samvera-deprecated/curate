require 'spec_helper'

describe CurationConcern::ImagesController do
  it_behaves_like 'is_a_curation_concern_controller', Image, actions: :all
end
