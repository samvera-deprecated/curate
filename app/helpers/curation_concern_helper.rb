module CurationConcernHelper
  def curation_concern_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(builder: CurationConcernFormBuilder)), &block)
  end
end
