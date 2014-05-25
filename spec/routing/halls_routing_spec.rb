require "spec_helper"

describe HallsController do
  describe "routing" do

#    it "routes to #index" do
#      get("/halls").should route_to("halls#index")
#    end

#    it "routes to #new" do
#      get("/halls/new").should route_to("halls#new")
#    end

    it "routes to #show" do
      get("/halls/1").should route_to("halls#show", :id => "1")
    end

    it "routes to #edit" do
      get("/halls/1/edit").should route_to("halls#edit", :id => "1")
    end

#    it "routes to #create" do
#      post("/halls").should route_to("halls#create")
#    end

    it "routes to #update" do
      put("/halls/1").should route_to("halls#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/halls/1").should route_to("halls#destroy", :id => "1")
    end

  end
end
