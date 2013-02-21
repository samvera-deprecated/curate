module CurationConcern
  module_function
  def mint_a_pid
    Sufia::Noid.namespaceize(Sufia::Noid.noidify(Sufia::IdService.mint))
  end
end