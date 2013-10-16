shared_examples 'doi_assignable' do
  its(:not_now_value_for_doi_assignment) { should be_kind_of(String) }
  it { should respond_to(:identifier) }
  it { should respond_to(:identifier=) }
  it { should respond_to(:doi_assignment_strategy=) }
  it { should respond_to(:doi_assignment_strategy) }
  it { subject.class.included_modules.should include CurationConcern::DoiAssignable }
end
