require 'spec_helper'

describe ApplicationHelper do
  it 'has #sufia as a "monkey-patch" for sufia gem' do
    expect(helper.sufia).to eq(helper)
  end

  it 'has #default_page_title' do
    expect(helper.default_page_title).to(
      eq("#{controller_name.titleize} // CurateND")
    )
  end

  it 'has #curation_concern_page_title' do
    expect(helper.curation_concern_page_title(SeniorThesis.new)).to(
      eq("New Senior Thesis // CurateND")
    )
  end

  it 'has #curation_concern_attribute_to_html' do
    collection = ["<h2>", "Johnny Tables"]
    object = double('curation_concern', things: collection)

    expect(helper.curation_concern_attribute_to_html(object, :things, "Weird")).to(
      eq("<dt>Weird</dt>\n<dd class=\"attribute things\">&lt;h2&gt;</dd>\n<dd class=\"attribute things\">Johnny Tables</dd>\n")
    )
  end

  it 'has #classify_for_display' do
    expect(helper.classify_for_display(SeniorThesis.new)).to eq('senior thesis')
  end

  describe '#bootstrap_navigation_element' do
    let(:path) { '/hello/world' }
    let(:name) { "Link Name"}
    it 'disables the navigation link to the active page' do
      helper.should_receive(:current_page?).with(path).and_return(true)
      expect(helper.bootstrap_navigation_element(name, path)).
        to have_tag('li.disabled a')
    end
    it 'does not disable a navigation link that is not the active page' do
      helper.should_receive(:current_page?).with(path).and_return(false)
      expect(helper.bootstrap_navigation_element(name, path)).
        to_not have_tag('li.disabled a')
    end
  end

  describe '#link_to_edit_permissions' do
    let(:solr_document) { {read_access_group_t: access_policy } }
    let(:user) { FactoryGirl.create(:user) }
    let(:curation_concern) {
      FactoryGirl.create_curation_concern(
        :senior_thesis, user, visibility: visibility
      )
    }
    let(:visibility) { nil }
    let(:access_policy) { nil }
    describe 'with a "registered" access group' do
      let(:expected_label) { "University of Notre Dame" }
      let(:visibility) { 'psu' } # Can we change this?
      let(:access_policy) { 'registered' }
      it 'renders a Notre Dame only label' do
        rendered = helper.link_to_edit_permissions(curation_concern, solr_document)
        expect(rendered).to(
          have_tag("a#permission_#{curation_concern.to_param}") {
            with_tag("span.label.label-info", with: {title: expected_label }, text: expected_label)
          }
        )
      end
    end
    describe 'with a "public" access group' do
      let(:expected_label) { "Open Access" }
      let(:access_policy) { 'public' }
      let(:visibility) { 'open'}
      it 'renders an "Open Access" label' do
        rendered = helper.link_to_edit_permissions(curation_concern, solr_document)
        expect(rendered).to(
          have_tag("a#permission_#{curation_concern.to_param}") {
            with_tag("span.label.label-success", with: {title: expected_label }, text: expected_label)
          }
        )
      end
    end
    describe 'with a mixed "public registered" access group' do
      # This test is purely speculative to the appropriate labeling behavior and
      # does not account for whether the document is truly accessable; I suppose
      # I'm persisting hash drive development via a Solr document
      let(:expected_label) { "Open Access" }
      let(:access_policy) { 'public registered' }
      it 'renders an "Open Access" label' do
        rendered = helper.link_to_edit_permissions(curation_concern, solr_document)
        expect(rendered).to(
          have_tag("a#permission_#{curation_concern.to_param}") {
            with_tag("span.label.label-success", with: {title: expected_label }, text: expected_label)
          }
        )
      end
    end
    describe 'without an access group' do
      let(:expected_label) { "Private" }
      let(:access_policy) { nil }
      let(:visibility) { 'restricted' }
      it 'renders an "Private" label' do
        rendered = helper.link_to_edit_permissions(curation_concern, solr_document)
        expect(rendered).to(
          have_tag("a#permission_#{curation_concern.to_param}") {
            with_tag("span.label.label-important", with: {title: expected_label }, text: expected_label)
          }
        )
      end
    end
  end
end
