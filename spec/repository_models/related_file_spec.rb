require 'spec_helper'
require "active_attr/rspec"

describe RelatedFile do
  subject { RelatedFile.new }
  it { should have_attribute :title}
  it { should have_attribute :file}
  it { should have_attribute :parent_curation_concern_id}
end