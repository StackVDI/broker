require "spec_helper"

describe ImagesController do
  describe "routing" do

    it "routes to #index" do
      get("/cloud_servers/1/images/").should route_to("images#index", :cloud_server_id => "1" )
    end

    it "routes to #new" do
      get("/cloud_servers/1/images/new").should route_to("images#new", :cloud_server_id => "1" )
    end

    it "routes to #show" do
      get("/cloud_servers/1/images/1").should route_to("images#show", :id => "1", :cloud_server_id => "1" )
    end

    it "routes to #edit" do
      get("/cloud_servers/1/images/1/edit").should route_to("images#edit", :id => "1", :cloud_server_id => "1" )
    end

    it "routes to #create" do
      post("/cloud_servers/1/images").should route_to("images#create", :cloud_server_id => "1" )
    end

    it "routes to #update" do
      put("/cloud_servers/1/images/1").should route_to("images#update", :id => "1", :cloud_server_id => "1" )
    end

    it "routes to #destroy" do
      delete("/cloud_servers/1/images/1").should route_to("images#destroy", :id => "1", :cloud_server_id => "1" )
    end

  end
end
