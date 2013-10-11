shared_examples 'it has linked contributors' do
  describe "nested contributors" do
    describe "without any creator" do
      it "should have an error" do
        subject.should_not be_valid
        subject.errors[:contributors].should == ["Your #{subject.human_readable_type.downcase} must have #{subject.indefinite_article} #{subject.contributor_label.downcase}."]
      end
    end

    describe "when nested attributes are set" do
      it "should create a new person" do
        expect {subject.contributors_attributes = [{name: 'Gaius Marius', id: ''}, {name: 'Marcus Junius Brutus', id: ''}, {name: '', id: ''}]}.to change{Person.count}.by(2)
        expect(subject.contributors.size).to eq 2
        expect(subject.contributors.first.name).to eq 'Gaius Marius'
        expect(subject.contributors.last.name).to eq 'Marcus Junius Brutus'
      end

      describe "when an exising person is specified" do
        let(:person1) { Person.create}
        let(:person2) { Person.create}
        before { subject.contributors = [person1] }

        after do
          person1.destroy
          person2.destroy
        end
        it "should attach that person" do
          subject.contributors_attributes = [{id: person2.pid }]
          subject.contributors.should == [person1, person2]
        end
      end
    end

    describe "when the object has a couple of contributors" do
      let(:person1) { FactoryGirl.create(:person) }
      let(:person2) { FactoryGirl.create(:person) }
      before { subject.contributors << person1 << person2 }

      after do
        person1.destroy
        person2.destroy
      end

      describe "setting the destroy bit in the contributors_attributes" do
        it "should remove an existing person" do
          subject.contributors_attributes = [{id: person1.pid, _destroy: true }]
          subject.contributors.should == [person2]
          Person.find(person1.pid).should_not be_nil
        end
      end

      describe "the solr document" do
        let(:solr_doc) { subject.to_solr }
        it "should include the contributors names" do
          solr_doc['desc_metadata__contributor_tesim'].should == [person1.name, person2.name]
        end
      end
    end
  end
end


