require 'spec_helper'

describe Hydramata::SolrHelper do
  before(:all) do
    class EmbargoMockController
      include Hydramata::SolrHelper

      attr_accessor :params

      def current_ability
        @current_ability ||= Ability.new(current_user)
      end

      def session
      end
    end


  end

  def mock_user
    @user = mock_model(User)
    @person = mock_model(Person)
    @user.stub(:manager?).and_return(false)
    @user.stub(:person).and_return(@person)
    @user.person.stub(:groups).and_return( [])
    @user
  end

  def mock_group
    @group=mock_model(Hydramata::Group)
    @group.stub(:pid).and_return("some_pid")
  end


  subject { EmbargoMockController.new }

  before do
    @solr_parameters = {}
    @user_parameters = {}
    subject.stub(:current_user).and_return(user)
  end

  describe "enforce_embargo" do
    let(:user) { mock_user }
    let(:depositor_field) { ActiveFedora::SolrService.solr_name('depositor', type: :string) }
    let(:user_key){ "bogus"}
    let(:pid){ "some_pid"}

    it "should include depositor user key in fq" do
      user.stub(:user_key).and_return(user_key)
      subject.enforce_embargo(@solr_parameters, @user_parameters)
      @solr_parameters[:fq].first.should include("#{depositor_field}:#{user_key}")
    end

    it "should include group filter if user has any groups" do
      user.person.stub(:groups).and_return( [mock_group])
      user.stub(:user_key).and_return(user_key)
      mock_group.stub(:pid).and_return(pid)
      subject.enforce_embargo(@solr_parameters, @user_parameters)
      @solr_parameters[:fq].first.should eq("(*:* NOT embargo_release_date_dtsi:[NOW TO *]) OR (embargo_release_date_dtsi:[NOW TO *] AND (discover_access_group_ssim:#{pid} OR read_access_group_ssim:some_pid OR edit_access_group_ssim:#{pid} )) OR (embargo_release_date_dtsi:[NOW TO *] AND #{depositor_field}:#{user_key})")
    end

    it "should not include any filter for manager in the solr query" do
      user.stub(:manager?).and_return(true)
      subject.stub(:current_user).and_return(user)
      subject.enforce_embargo(@solr_parameters, @user_parameters)
      @solr_parameters[:fq].reject(&:empty?).empty?.should be_truthy
    end

    it "user not logged in include only embargo filter" do
      subject.stub(:current_user).and_return(nil)
      subject.enforce_embargo(@solr_parameters, @user_parameters)
      @solr_parameters[:fq].first.should eq("(*:* NOT embargo_release_date_dtsi:[NOW TO *])")
    end


  end

end
