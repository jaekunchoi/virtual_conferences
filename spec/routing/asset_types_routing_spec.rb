require "spec_helper"

describe AssetTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/asset_types").should route_to("asset_types#index")
    end

#    it "routes to #new" do
#      get("/asset_types/new").should route_to("asset_types#new")
#    end

    it "routes to #show" do
      get("/asset_types/1").should route_to("asset_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/asset_types/1/edit").should route_to("asset_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/asset_types").should route_to("asset_types#create")
    end

    it "routes to #update" do
      put("/asset_types/1").should route_to("asset_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/asset_types/1").should route_to("asset_types#destroy", :id => "1")
    end

  end
end
