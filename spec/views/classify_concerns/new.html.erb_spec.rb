require 'spec_helper'

describe 'classify_concerns/new.html.erb' do
  let(:classes) { [GenericWork, Article, Dataset, Image, Document, Etd, Spam] }
  it 'displays curation_concerns with access' do
    classes.each do |klass|
      allow(view).to receive(:can?).with(:create, klass) { true }
    end
    allow(view).to receive(:classify_concern) { stub_model(ClassifyConcern)}
    render
    expect(rendered).to match /Generic Work/
    expect(rendered).to match /Article/
    expect(rendered).to match /Image/
  end

  it 'hides curation_concerns without access' do
    (classes - [Image]).each do |klass|
      allow(view).to receive(:can?).with(:create, klass) { true }
    end
    allow(view).to receive(:can?).with(:create, Image) { false }
    allow(view).to receive(:classify_concern) { stub_model(ClassifyConcern)}
    render
    expect(rendered).to match /Generic Work/
    expect(rendered).to match /Article/
    expect(rendered).to_not match /Image/
  end
end
