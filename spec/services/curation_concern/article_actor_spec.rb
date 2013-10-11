require 'spec_helper'

describe CurationConcern::ArticleActor do
  it_behaves_like 'is_a_curation_concern_actor', Article
end
