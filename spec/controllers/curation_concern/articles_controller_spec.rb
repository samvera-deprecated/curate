require 'spec_helper'

describe CurationConcern::ArticlesController do
  it_behaves_like 'is_a_curation_concern_controller', Article, actions: :all
end