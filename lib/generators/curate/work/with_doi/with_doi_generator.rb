# -*- encoding : utf-8 -*-
require 'rails/generators'

module Curate::Work
  class WithDoiGenerator <  Rails::Generators::Base
    argument :targets, type: :array, required: true, banner: "target, target"
    def append_doi_initializer
      options = targets
      options << [%(--target='{|obj| Curate.permanent_url_for(obj) }')]
      options << [%(--creator=:creator)]
      options << [%(--title=:title)]
      options << [%(--publisher='{|o| Array(o.publisher).join("; ")}')]
      options << [%(--publication_year='{|o| o.date_uploaded.year }')]
      options << [%(--set_identifier='{|o,value| o.identifier = value; o.save }')]
      args = ['hydra:remote_identifier:doi', options.join(" ")]

      if behavior == :revoke
        destroy(*args)
      else
        generate(*args)
      end

    end

  end
end