require 'spec_helper'

describe CurationConcern do
  subject {CurationConcern}
  it 'can mint_a_pid' do
    subject.should respond_to(:mint_a_pid)
  end
  it 'finds an actor by for a SeniorThesis' do
    subject.actor(SeniorThesis.new, User.new, {}).should(
      be_kind_of(CurationConcern::SeniorThesisActor)
    )
  end

  it 'raise an exception if there is no actor' do
    expect {
      subject.actor("", User.new, {})
    }.to raise_error(NameError)

  end
end
