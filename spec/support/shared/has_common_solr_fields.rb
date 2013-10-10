shared_examples 'has_common_solr_fields' do
  let(:solr_doc) { subject.to_solr }

  it "should index concrete an abstract type" do
    solr_doc['human_readable_type_sim'].should == subject.human_readable_type
    solr_doc['generic_type_sim'].should == ['Work']
  end

end
