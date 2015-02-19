require "rails_helper"

RSpec.describe EnviromentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/enviroments").to route_to("enviroments#index")
    end

    it "routes to #new" do
      expect(:get => "/enviroments/new").to route_to("enviroments#new")
    end

    it "routes to #show" do
      expect(:get => "/enviroments/1").to route_to("enviroments#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/enviroments/1/edit").to route_to("enviroments#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/enviroments").to route_to("enviroments#create")
    end

    it "routes to #update" do
      expect(:put => "/enviroments/1").to route_to("enviroments#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/enviroments/1").to route_to("enviroments#destroy", :id => "1")
    end

  end
end
