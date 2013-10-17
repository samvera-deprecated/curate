module Curate
  class DateFormatter

    def self.parse(date_string)
      date_string = date_string.strip
      return nil if unparseable_date?(date_string)

      if is_a_year?(date_string)
        Date.new(date_string.to_i)
      else
        date = Chronic.parse(date_string)
        date.to_date if date
      end
    end

private

    # Some date inputs can't be used to create a 
    # searchable/sortable date in solr.
    # For example:  "3rd century BCE"
    def self.unparseable_date?(input_string)
      fuzzy_date_terms = ['bce', 'century']
      fuzzy_date_terms.any? do |term|
        regex = Regexp.new(term, Regexp::IGNORECASE)
        input_string.match(regex)
      end
    end

    def self.is_a_year?(input_string)
      four_digit_year = %r{^\d{4}\z}
      !input_string.match(four_digit_year).nil?
    end

  end
end
