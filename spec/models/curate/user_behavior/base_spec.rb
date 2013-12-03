require 'spec_helper'

describe Curate::UserBehavior::Base do
  let(:model) do
    Class.new do
      include Curate::UserBehavior::Base
      def initialize(object)
        @object = object
      end
      def method_missing(method_name, *args, &block)
        @object.send(method_name, *args, &block)
      end
      def respond_to_missing?(method_name, *args, &block)
        @object.respond_to?(method_name, *args, &block)
      end
    end
  end
  let(:noid) { 'abc-123'}
  let(:user) { double(repository_id: Sufia::Noid.namespaceize(noid), repository_id?: true)}
  subject { model.new(user) }
  its(:repository_noid) { should eq noid }
  its(:repository_noid?) { should eq true }
end
