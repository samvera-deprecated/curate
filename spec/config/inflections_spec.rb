require 'spec_helper'

describe 'inflections' do
  it 'plural of "thesis" is "theses"' do
    "thesis".pluralize.should == 'theses'
  end
  it 'singular of "theses" is "thesis"' do
    "theses".singularize.should == 'thesis'
  end

  it '"senior_thesis" should classify to SeniorThesis' do
    "senior_thesis".classify.should == "SeniorThesis"
  end

  it '"senior_theses" should classify to SeniorThesis' do
    "senior_theses".classify.should == "SeniorThesis"
  end
end