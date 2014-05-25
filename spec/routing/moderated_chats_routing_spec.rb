require "spec_helper"

describe ModeratedChatsController do
  describe "routing" do

    it "routes to #index" do
      get("/moderated_chats").should route_to("moderated_chats#index")
    end

#    it "routes to #new" do
#      get("/moderated_chats/new").should route_to("moderated_chats#new")
#    end

    it "routes to #show" do
      get("/moderated_chats/1").should route_to("moderated_chats#show", :id => "1")
    end

    it "routes to #edit" do
      get("/moderated_chats/1/edit").should route_to("moderated_chats#edit", :id => "1")
    end

    it "routes to #create" do
      post("/moderated_chats").should route_to("moderated_chats#create")
    end

    it "routes to #update" do
      put("/moderated_chats/1").should route_to("moderated_chats#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/moderated_chats/1").should route_to("moderated_chats#destroy", :id => "1")
    end

  end
end
