class EmbargoValidator < ActiveModel::Validator

  def validate(record)
    if record.embargo_release_date.present?
      begin
        Date.parse(record.embargo_release_date)
        record.errors[:embargo_release_date] << "Must be a future date" unless Date.parse(record.embargo_release_date)> Date.today
      rescue
        record.errors[:embargo_release_date] << "Invalid Date Format"
        return
      end

    end
  end

end