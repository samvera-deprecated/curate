shared_examples 'doi_assignable' do
  it { should respond_to(:identifier) }
  it { should respond_to(:identifier=) }
  it { should respond_to(:existing_identifier) }
  it { should respond_to(:existing_identifier=) }
  it { should respond_to(:doi_assignment_strategy=) }
  it { should respond_to(:doi_assignment_strategy) }
  it { subject.class.included_modules.should include CurationConcern::DoiAssignable }
end
