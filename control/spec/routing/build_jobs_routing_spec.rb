require "rails_helper"

RSpec.describe BuildJobsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/build_jobs").to route_to("build_jobs#index")
    end

    it "routes to #new" do
      expect(:get => "/build_jobs/new").to route_to("build_jobs#new")
    end

    it "routes to #show" do
      expect(:get => "/build_jobs/1").to route_to("build_jobs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/build_jobs/1/edit").to route_to("build_jobs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/build_jobs").to route_to("build_jobs#create")
    end

    it "routes to #update" do
      expect(:put => "/build_jobs/1").to route_to("build_jobs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/build_jobs/1").to route_to("build_jobs#destroy", :id => "1")
    end

  end
end
