require 'spec_helper'

module Curate

  describe DateFormatter do

    describe 'parse: ' do
      it 'parses normal dates' do
        expected_result = Date.parse('2012-4-5')
        Curate::DateFormatter.parse('2012-4-5').should == expected_result
      end

      it 'parses year-and-month dates' do
        parsed_date = Curate::DateFormatter.parse('2012-4')
        parsed_date.year.should == 2012
        parsed_date.month.should == 4
      end

      it 'parses year-only dates' do
        expected_result = Date.parse('2012-1-1')
        Curate::DateFormatter.parse('2012').should == expected_result
        Curate::DateFormatter.parse('2012 ').should == expected_result
      end

      it 'gracefully handles un-parseable dates' do
        Curate::DateFormatter.parse('something unparseable').should be_nil
        Curate::DateFormatter.parse('500 BCE').should be_nil
        Curate::DateFormatter.parse('17th century').should be_nil
      end
    end

  end
end
