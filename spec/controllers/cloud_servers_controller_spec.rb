require 'spec_helper'

describe CloudServersController do

  let(:valid_attributes) { { "name" => "MyString" } }
  let(:valid_session) { {} }

  context "logged as an admin" do

  before do
    @user = FactoryGirl.build(:user, :approved => true)
    @user.add_role :admin
    @user.confirm!
    @user.save
    sign_in @user
  end

  describe "GET index" do
    it "assigns all cloud_servers as @cloud_servers" do
      cloud_server = CloudServer.create! valid_attributes
      get :index, {}, valid_session
      assigns(:cloud_servers).should eq([cloud_server])
    end
  end

  describe "GET show" do
    it "assigns the requested cloud_server as @cloud_server" do
      cloud_server = CloudServer.create! valid_attributes
      get :show, {:id => cloud_server.to_param}, valid_session
      assigns(:cloud_server).should eq(cloud_server)
    end
  end

  describe "GET new" do
    it "assigns a new cloud_server as @cloud_server" do
      get :new, {}, valid_session
      assigns(:cloud_server).should be_a_new(CloudServer)
    end
  end

  describe "GET edit" do
    it "assigns the requested cloud_server as @cloud_server" do
      cloud_server = CloudServer.create! valid_attributes
      get :edit, {:id => cloud_server.to_param}, valid_session
      assigns(:cloud_server).should eq(cloud_server)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new CloudServer" do
        expect {
          post :create, {:cloud_server => valid_attributes}, valid_session
        }.to change(CloudServer, :count).by(1)
      end

      it "assigns a newly created cloud_server as @cloud_server" do
        post :create, {:cloud_server => valid_attributes}, valid_session
        assigns(:cloud_server).should be_a(CloudServer)
        assigns(:cloud_server).should be_persisted
      end

      it "redirects to the created cloud_server" do
        post :create, {:cloud_server => valid_attributes}, valid_session
        response.should redirect_to(cloud_servers_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved cloud_server as @cloud_server" do
        # Trigger the behavior that occurs when invalid params are submitted
        CloudServer.any_instance.stub(:save).and_return(false)
        post :create, {:cloud_server => { "name" => "invalid value" }}, valid_session
        assigns(:cloud_server).should be_a_new(CloudServer)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        CloudServer.any_instance.stub(:save).and_return(false)
        post :create, {:cloud_server => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested cloud_server" do
        cloud_server = CloudServer.create! valid_attributes
        # Assuming there are no other cloud_servers in the database, this
        # specifies that the CloudServer created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        CloudServer.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => cloud_server.to_param, :cloud_server => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested cloud_server as @cloud_server" do
        cloud_server = CloudServer.create! valid_attributes
        put :update, {:id => cloud_server.to_param, :cloud_server => valid_attributes}, valid_session
        assigns(:cloud_server).should eq(cloud_server)
      end

      it "redirects to the cloud_server" do
        cloud_server = CloudServer.create! valid_attributes
        put :update, {:id => cloud_server.to_param, :cloud_server => valid_attributes}, valid_session
        response.should redirect_to(cloud_servers_path)
      end
    end

    describe "with invalid params" do
      it "assigns the cloud_server as @cloud_server" do
        cloud_server = CloudServer.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        CloudServer.any_instance.stub(:save).and_return(false)
        put :update, {:id => cloud_server.to_param, :cloud_server => { "name" => "invalid value" }}, valid_session
        assigns(:cloud_server).should eq(cloud_server)
      end

      it "re-renders the 'edit' template" do
        cloud_server = CloudServer.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        CloudServer.any_instance.stub(:save).and_return(false)
        put :update, {:id => cloud_server.to_param, :cloud_server => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested cloud_server" do
      cloud_server = CloudServer.create! valid_attributes
      expect {
        delete :destroy, {:id => cloud_server.to_param}, valid_session
      }.to change(CloudServer, :count).by(-1)
    end

    it "redirects to the cloud_servers list" do
      cloud_server = CloudServer.create! valid_attributes
      delete :destroy, {:id => cloud_server.to_param}, valid_session
      response.should redirect_to(cloud_servers_url)
    end
  end
  end

  context "logged as an user" do
    before do
      @user = FactoryGirl.build(:user, :approved => true)
      @user.confirm!
      @user.save
      sign_in @user
    end

    describe "GET index" do
      it "get an unauthorized error" do
        get 'index'
        expect(response).to_not be_success
      end
    end

    describe "GET show" do
      it "get an unauthorized error" do
        cloud_server = CloudServer.create! valid_attributes
        get :show, {:id => cloud_server.to_param}
        expect(response).to_not be_success
      end
    end

    describe "GET new" do
      it "get an unauthorized error" do
        get :new, {}, valid_session
        expect(response).to_not be_success
      end
    end

    describe "GET edit" do
      it "get an unauthorized error" do
        cloud_server = CloudServer.create! valid_attributes
        get :edit, {:id => cloud_server.to_param}
        expect(response).to_not be_success
      end
    end

    describe "POST create" do
      it "get an unauthorized error" do
        post :create, {:cloud_server => valid_attributes}
        expect(response).to_not be_success
      end
    end
  end

end
