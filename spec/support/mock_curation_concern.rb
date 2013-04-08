class MockCurationConcern < ActiveFedora::Base
  has_many :generic_files, property: :is_part_of

  after_destroy :after_destroy_cleanup
  def after_destroy_cleanup
    generic_files.each(&:destroy)
  end
end
