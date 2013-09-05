# RSpec matcher to spec delegations.

RSpec::Matchers.define :have_unique_field do |expected_field_name|
  match do |subject|
    subject.should respond_to(expected_field_name)
    subject.send(expected_field_name).should be_nil
  end

  description do
    "expected to have a single-valued field named #{expected_field_name}"
  end

  failure_message_for_should do |subject|
    "#{subject.inspect} should respond to #{expected_field_name} as a single-value, not an Array. Responded with #{subject.send(expected_field_name)}"
  end
end

RSpec::Matchers.define :have_multivalue_field do |expected_field_name|
  match do |subject|
    subject.should respond_to(expected_field_name)
    subject.send(expected_field_name).should be_instance_of Array
  end

  description do
    "expected to have a multi-valued field named #{expected_field_name}"
  end
end