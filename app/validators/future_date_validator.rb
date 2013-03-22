class FutureDateValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.present?
      begin
        Date.parse(value)
        record.errors[:embargo_release_date] << "Must be a future date" unless Date.parse(value)> Date.today
      rescue ArgumentError => e
        record.errors[:embargo_release_date] << "Invalid Date Format"
        return
      end

    end
  end

end