class DoiWorker
  def queue_name
    :doi
  end

  attr_accessor :generic_file_id

  def initialize(generic_file_id)
    self.generic_file_id = generic_file_id
  end

  def run
    mint_doi = MintDoi.new
    mint_doi.mint_doi(generic_file_id)
  end
end
