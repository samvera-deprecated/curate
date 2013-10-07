require 'spec_helper'

describe CurationConcern::GenericWorksController do
  include_examples 'is_a_curation_concern_controller', GenericWork, actions: :all
end
