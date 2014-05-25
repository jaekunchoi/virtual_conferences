require "spec_helper"

describe WebcastsController do
  describe "routing" do

#    it "routes to #index" do
#      get("/webcasts").should route_to("webcasts#index")
#    end

#    it "routes to #new" do
#      get("/webcasts/new").should route_to("webcasts#new")
#    end

    it "routes to #show" do
      get("/webcasts/1").should route_to("webcasts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/webcasts/1/edit").should route_to("webcasts#edit", :id => "1")
    end

#    it "routes to #create" do
#      post("/webcasts").should route_to("webcasts#create")
#    end

    it "routes to #update" do
      put("/webcasts/1").should route_to("webcasts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/webcasts/1").should route_to("webcasts#destroy", :id => "1")
    end

  end
end
