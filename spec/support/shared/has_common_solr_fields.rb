shared_examples 'has_common_solr_fields' do
  let(:solr_doc) { subject.to_solr}

  it "should index concrete an abstract type" do
    subject.save(validate: false) # save causes a callback which sets archived_object_type
    solr_doc['desc_metadata__archived_object_type_sim'].should == [subject.human_readable_type]
    solr_doc['desc_metadata__resource_type_sim'].should == ['Work']
  end

end

