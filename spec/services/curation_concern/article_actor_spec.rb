require 'spec_helper'

describe CurationConcern::ArticleActor do
  include_examples 'is_a_curation_concern_actor', Article
end
