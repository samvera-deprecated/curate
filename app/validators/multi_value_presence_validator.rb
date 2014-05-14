class MultiValuePresenceValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, input)
    values = Array.wrap(input)
    record.errors.add(attribute, :blank, options) unless values.any?(&:present?)
  end

end
