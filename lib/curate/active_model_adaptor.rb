module Curate
  module ActiveModelAdaptor
    def to_key
      persisted? ? [Sufia.config.id_namespace, noid] : nil
    end

    def to_param
      persisted? ? noid : nil
    end

    def noid
      Sufia::Noid.noidify(pid) if pid
    end
  end
end
