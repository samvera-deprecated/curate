shared_examples 'has_linked_creators' do
  describe "nested creators" do
    it "should create a new person" do
      expect {subject.creators_attributes = [{name: 'Gaius Marius', id: ''}, {name: 'Marcus Junius Brutus', id: ''}, {name: '', id: ''}]}.to change{Person.count}.by(2)
      expect(subject.creators.size).to eq 2
      expect(subject.creators.first.name).to eq 'Gaius Marius'
      expect(subject.creators.last.name).to eq 'Marcus Junius Brutus'
    end

    describe "when attaching an exising person" do
      let(:person1) { Person.create}
      let(:person2) { Person.create}
      before { subject.creators = [person1] }

      after do
        person1.destroy
        person2.destroy
      end
      it "should attach" do
        subject.creators_attributes = [{id: person2.pid }]
        subject.creators.should == [person1, person2]
      end
    end

    describe "when the object has a creator" do
      let(:person1) { Person.create}
      let(:person2) { Person.create}
      before { subject.creators = [person1, person2] }

      after do
        person1.destroy
        person2.destroy
      end

      it "should remove an existing person" do
        subject.creators_attributes = [{id: person1.pid, _destroy: true }]
        subject.creators.should == [person2]
        Person.find(person1.pid).should_not be_nil
      end
    end
  end

end


