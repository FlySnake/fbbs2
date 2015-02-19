require "rails_helper"

RSpec.describe BuildNumbersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/build_numbers").to route_to("build_numbers#index")
    end

    it "routes to #new" do
      expect(:get => "/build_numbers/new").to route_to("build_numbers#new")
    end

    it "routes to #show" do
      expect(:get => "/build_numbers/1").to route_to("build_numbers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/build_numbers/1/edit").to route_to("build_numbers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/build_numbers").to route_to("build_numbers#create")
    end

    it "routes to #update" do
      expect(:put => "/build_numbers/1").to route_to("build_numbers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/build_numbers/1").to route_to("build_numbers#destroy", :id => "1")
    end

  end
end
