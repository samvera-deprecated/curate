describe "#destroy" do
  let(:work_to_be_deleted) { FactoryGirl.create(default_work_factory_name, user: user) }
  let(:generic_file) { FactoryGirl.create_generic_file(:work_to_be_deleted, user,
      curate_fixture_file_upload('files/image.png', 'image/png', false)) {|g| g.visibility = visibility }
  it "should delete the work" do
    delete :destroy, id: work_to_be_deleted
    expect { GenericWork.find(work_to_be_deleted.pid) }.to raise_error
  end
  it 'should be successful if file exists' do
    parent = generic_file.batch
    sign_in(user)
    delete :destroy, id: generic_file.to_param
    expect(response.status).to eq(302)
    expect(response).to redirect_to(controller.polymorphic_path([:curation_concern, parent]))
  end
end

