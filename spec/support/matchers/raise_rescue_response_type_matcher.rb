# RSpec matcher to spec delegations.

RSpec::Matchers.define :raise_rescue_response_type do |expected_rescue_response|
  match do |response|
    @expected_rescue_response = expected_rescue_response.to_sym
    @exception = nil
    begin
      response.call
    rescue Exception => e
      @exception = e
    end

    if @exception.nil?
      raise "expected to raise an exception with rescue_response #{expected_rescue_response.to_sym.inspect}"
    end
    @actual_rescue_response = ActionDispatch::ExceptionWrapper.rescue_responses[@exception.class.name].to_sym
    @actual_rescue_response == @expected_rescue_response
  end

  description do
    "expected to raise an exception with rescue_response #{@expected_rescue_response.inspect}"
  end

  failure_message_for_should do |text|
    "expected to raise an exception with rescue_response #{@expected_rescue_responsee.inspect} instead got #{@actual_rescue_response.inspect}"
  end

  failure_message_for_should_not do |text|
    "expected to NOT raise an exception with rescue_response #{@expected_rescue_responsee.inspect} but got #{@actual_rescue_response.inspect}"
  end

end
