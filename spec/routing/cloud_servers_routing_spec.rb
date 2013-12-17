require "spec_helper"

describe CloudServersController do
  describe "routing" do

    it "routes to #index" do
      get("/cloud_servers").should route_to("cloud_servers#index")
    end

    it "routes to #new" do
      get("/cloud_servers/new").should route_to("cloud_servers#new")
    end

    it "routes to #show" do
      get("/cloud_servers/1").should route_to("cloud_servers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/cloud_servers/1/edit").should route_to("cloud_servers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/cloud_servers").should route_to("cloud_servers#create")
    end

    it "routes to #update" do
      put("/cloud_servers/1").should route_to("cloud_servers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/cloud_servers/1").should route_to("cloud_servers#destroy", :id => "1")
    end

  end
end
