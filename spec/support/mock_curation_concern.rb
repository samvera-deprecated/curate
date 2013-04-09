class MockCurationConcern < ActiveFedora::Base
  include CurationConcern::WithAccessRight

  has_many :generic_files, property: :is_part_of

  after_destroy :after_destroy_cleanup
  def after_destroy_cleanup
    generic_files.each(&:destroy)
  end

  def human_readable_type
    self.class.to_s.demodulize.titleize
  end
  def to_param
    pid.split(':').last
  end
end
