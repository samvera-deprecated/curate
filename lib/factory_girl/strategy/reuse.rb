require 'factory_girl'

module FactoryGirl
  module Strategy
    class Reuse < FactoryGirl::Strategy::Create
      class_attribute :reuse_cache
      self.reuse_cache = {}
      def result(evaluation)
        key = evaluation.object.class.name
        reuse_cache[key] ||=  super
      end
    end
  end
end

FactoryGirl.register_strategy(:reuse, FactoryGirl::Strategy::Reuse)
