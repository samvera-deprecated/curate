require 'spec_helper'

describe CurationConcern::DocumentsController do

  include_examples 'is_a_curation_concern_controller', Document, actions: :all

end

