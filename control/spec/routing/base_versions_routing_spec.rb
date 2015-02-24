require "rails_helper"

RSpec.describe BaseVersionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/base_versions").to route_to("base_versions#index")
    end

    it "routes to #new" do
      expect(:get => "/base_versions/new").to route_to("base_versions#new")
    end

    it "routes to #show" do
      expect(:get => "/base_versions/1").to route_to("base_versions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/base_versions/1/edit").to route_to("base_versions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/base_versions").to route_to("base_versions#create")
    end

    it "routes to #update" do
      expect(:put => "/base_versions/1").to route_to("base_versions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/base_versions/1").to route_to("base_versions#destroy", :id => "1")
    end

  end
end
