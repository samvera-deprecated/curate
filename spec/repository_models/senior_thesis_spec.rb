require 'spec_helper'

describe SeniorThesis do
  subject { FactoryGirl.build(:senior_thesis, title: 'Title') }

  include_examples('with_access_rights')
  include_examples('is_embargoable')

  it { should respond_to(:human_readable_type) }
  it { should respond_to(:visibility) }
  it { should respond_to(:visibility=) }

  it('has a title') { subject.should respond_to(:title) }
  it('has a created') { subject.should respond_to(:created) }
  it('has an description') { subject.should respond_to(:description) }
  it('has a contributor') { subject.should respond_to(:contributor) }
  it('has a creator') { subject.should respond_to(:creator) }
  it('has a date_uploaded') { subject.should respond_to(:date_uploaded) }
  it('has a date_modified') { subject.should respond_to(:date_modified) }
  it('has a available') { subject.should respond_to(:available) }
  it('has a publisher') { subject.should respond_to(:publisher) }
  it('has a bibliographic_citation') { subject.should respond_to(:bibliographic_citation) }
  it('has a source') { subject.should respond_to(:source) }
  it('has a language') { subject.should respond_to(:language) }
  it('has a archived_object_type') { subject.should respond_to(:archived_object_type) }
  it('has a content_format') { subject.should respond_to(:content_format) }
  it('has a extent') { subject.should respond_to(:extent) }
  it('has a requires') { subject.should respond_to(:requires) }
  it('has a subject') { subject.should respond_to(:subject) }

  it 'uses #noid for #to_param' do
    subject.to_param.should == subject.noid
  end

  describe 'contributor' do
    it 'normalizes input to "Last Name, First Name"' do
      subject.contributor = [
        'Washington, George', 'John Lennon','Prof. Hubert J. Farnsworth'
      ]
      expect(subject.contributor).to eq(
        [
          'George Washington', 'John Lennon', 'Prof. Hubert J. Farnsworth'
        ]
      )
    end
  end

end
