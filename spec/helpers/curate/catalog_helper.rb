require 'spec_helper'

describe Curate::CatalogHelper do
  field = 'generic_type_sim'
  
  before do
    helper.stub(:blacklight_config => double(:facet_fields => {}))
    helper.params[:controller] = :catalog
    helper.params[:action] = :index
    helper.params[:q] = 'exceptional deposits' 
  end
  describe "type_tab" do
    describe "when #{field} equals the specified value" do
      before { params[:f] = {field => ['Collection']}}
      it "should be active" do
        helper.type_tab("Collections", "Collection").should == "<li class=\"active\"><a href=\"#\">Collections</a></li>"
      end
    end
    describe "when #{field} is not equal to the specified value" do
      before { params[:f] = {field => ['Person']}}
      it "should have a link" do
        helper.type_tab("Collections", "Collection").should == 
          "<li><a href=\"/catalog?f%5B#{field}%5D%5B%5D=Collection&amp;q=exceptional+deposits\">Collections</a></li>"
      end
    end
    describe "when #{field} is not set" do
      it "should have a link" do
        helper.type_tab("Collections", "Collection").should == 
          "<li><a href=\"/catalog?f%5B#{field}%5D%5B%5D=Collection&amp;q=exceptional+deposits\">Collections</a></li>"
      end
    end
  end
  describe "all_type_tab" do
    describe "when #{field} is not set" do
      it "should be active" do
        helper.all_type_tab.should == "<li class=\"active\"><a href=\"#\">All</a></li>"
      end
    end
    describe "when #{field} is set" do
      before { params[:f] = {field => ['Person']}}
      it "should have a link" do
        helper.all_type_tab.should == 
          "<li><a href=\"/catalog?q=exceptional+deposits\">All</a></li>"
      end
    end
  end
  describe "show section type for my assets" do
    describe "works catalog" do
      before { params[:f] = {field => ['Work']}}
      it "should display Works in the 'Show' section" do
        helper.catalog_type.should == "Works"
      end
    end

    describe "collections catalog" do
      before { params[:f] = {field => ['Collection']}}
      it "should display Collections in the 'Show' section" do
        helper.catalog_type.should == "Collections"
      end
    end

    describe "people catalog" do
      before { params[:f] = {field => ['Person']}}
      it "should display Profile in the 'Show' section" do
        helper.catalog_type.should == "Profile"
      end
    end

    describe "everything" do
      before { params[:f] = {field => ['All']}}
      it "should display Content in the 'Show' section" do
        helper.catalog_type.should == "Content"
      end
    end
  end
end
