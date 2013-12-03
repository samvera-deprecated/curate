class QuickClassificationQuery
  CURATION_CONCERNS_TO_TRY = ['article', 'dataset', 'image']

  def self.each_for_context(*args, &block)
    new(*args).all.each(&block)
  end

  attr_reader :user

  def initialize(user, options = {})
    @user = user
    @concern_name_normalizer = options.fetch(:concern_name_normalizer, ClassifyConcern.method(:normalize_concern_name))
    @registered_curation_concern_names = options.fetch(:registered_curation_concern_names, Curate.configuration.registered_curation_concern_types)
    @curation_concern_names_to_try = options.fetch(:curation_concern_names_to_try, CURATION_CONCERNS_TO_TRY)
  end

  def all
    (registered_curation_concern_names & normalized_curation_concern_names).sort.collect(&:constantize).select {|klass| user.can?(:create, klass)}
  end

  private
  attr_reader :concern_name_normalizer, :registered_curation_concern_names, :curation_concern_names_to_try
  def normalized_curation_concern_names
    curation_concern_names_to_try.collect{|name| concern_name_normalizer.call(name) }
  end
end
