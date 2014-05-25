require "spec_helper"

describe LiteraturesController do
  describe "routing" do

    it "routes to #index" do
      get("/literatures").should route_to("literatures#index")
    end

    it "routes to #new" do
      get("/literatures/new").should route_to("literatures#new")
    end

    it "routes to #show" do
      get("/literatures/1").should route_to("literatures#show", :id => "1")
    end

    it "routes to #edit" do
      get("/literatures/1/edit").should route_to("literatures#edit", :id => "1")
    end

    it "routes to #create" do
      post("/literatures").should route_to("literatures#create")
    end

    it "routes to #update" do
      put("/literatures/1").should route_to("literatures#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/literatures/1").should route_to("literatures#destroy", :id => "1")
    end

  end
end
