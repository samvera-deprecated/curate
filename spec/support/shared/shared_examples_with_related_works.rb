shared_examples 'with_related_works' do
  let(:user) { FactoryGirl.create(:user) }
  let(:work) { FactoryGirl.create(:generic_work, user: user, title:"My Fabulous Work") }
  let(:dataset) { FactoryGirl.create(:dataset, user: user, title:"Records from that Kiki") }

  before do
    subject.apply_depositor_metadata(user.user_key)
    subject.contributor << 'Some Body'
    subject.save!
  end

  it "should track relations to other works" do
    subject.related_works << dataset
    subject.save
    subject.reload
    subject.related_works.should == [dataset]
    subject.related_work_ids.should == [dataset.pid]
    subject.related_works << work
    subject.related_works.should == [dataset, work]
    subject.related_works = [work]
    # Deleting via nested_attributes isn't currently supported by AF.  If it was, you could do this:
    #subject.update_attributes(related_works_attributes:[{id:dataset.pid, _delete:true}])
    subject.related_works.should == [work]
  end
end
