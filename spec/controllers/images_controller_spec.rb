require 'spec_helper'

describe ImagesController do

  let(:valid_attributes) { {  :cloud_server => @cloud_server,
                              :name => "MyImage", 
                              :description => "My Description", 
                              :machine => "windows7",
                              :flavor => "m1.medium",
                              :number_of_instances => 2
                          } }


  context "as an admin" do
  before do
    @user = FactoryGirl.build(:user, :approved => true)
    @user.add_role :admin
    @user.confirm!
    @user.save
    sign_in @user
    @cloud_server = FactoryGirl.build(:cloud_server, :username => 'adan', :password => 'cambiame', :url => 'http://nube.inf.um.es:5000/v2.0/')
    @cloud_server.save
  end

  describe "get show" do
    it "assign the image to @image" do
      image = Image.create! valid_attributes
      get :show, {:id => image.to_param, :cloud_server_id => @cloud_server.id}
      assigns(:image).should eq(image)
    end
  end

  describe "get index" do
    it "assigns all images as @images" do
      image = Image.create! valid_attributes
      get :index, :cloud_server_id => @cloud_server.id
      assigns(:images).should eq([image])
    end
  end

  describe "GET new" do
    it "assigns a new image as @image" do
      VCR.use_cassette('images_get_new') do
        get :new, :cloud_server_id => @cloud_server.id
      end
      assigns(:image).should be_a_new(Image)
    end
  end

  describe "GET edit" do
    it "assigns the requested image as @image" do
      image = Image.create! valid_attributes
      get :edit, {:id => image.to_param, :cloud_server_id => @cloud_server.id}
      assigns(:image).should eq(image)
    end
  end

  describe "post create" do
    describe "with valid params" do
      it "creates a new image" do
        expect {
          post :create, {:image => valid_attributes, :cloud_server_id => @cloud_server.id}
        }.to change(Image, :count).by(1)
      end

      it "assigns a newly created image as @image" do
        post :create, {:image => valid_attributes, :cloud_server_id => @cloud_server.id}
        assigns(:image).should be_a(Image)
        assigns(:image).should be_persisted
      end

      it "redirects to the created image" do
        post :create, {:image => valid_attributes, :cloud_server_id => @cloud_server.id}
        response.should redirect_to(cloud_server_images_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved image as @image" do
        # trigger the behavior that occurs when invalid params are submitted
        Image.any_instance.stub(:save).and_return(false)
        post :create, {:image => { "name" => "invalid value" }, :cloud_server_id => @cloud_server.id}
        assigns(:image).should be_a_new(Image)
      end

      it "re-renders the 'new' template" do
        # trigger the behavior that occurs when invalid params are submitted
        Image.any_instance.stub(:save).and_return(false)
        post :create, {:image => { "name" => "invalid value" }, :cloud_server_id => @cloud_server.id}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested image" do
        image = Image.create! valid_attributes
        # Assuming there are no other images in the database, this
        # specifies that the Image created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Image.any_instance.should_receive(:update).with("name" => "updated name")
        put :update, {:id => image.to_param, :image => {"name" => "updated name"}, :cloud_server_id => @cloud_server.id}
      end

      it "assigns the requested image as @image" do
        image = Image.create! valid_attributes
        put :update, {:id => image.to_param, :image => valid_attributes, :cloud_server_id => @cloud_server.id}
        assigns(:image).should eq(image)
      end

      it "redirects to the images list" do
        image = Image.create! valid_attributes
        put :update, {:id => image.to_param, :image => valid_attributes, :cloud_server_id => @cloud_server.id}
        response.should redirect_to(cloud_server_images_path)
      end
    end

    describe "with invalid params" do
      it "assigns the image as @image" do
        image = Image.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Image.any_instance.stub(:save).and_return(false)
        put :update, {:id => image.to_param, :image => { "name" => "invalid value" }, :cloud_server_id => @cloud_server.id}
        assigns(:image).should eq(image)
      end

      it "re-renders the 'edit' template" do
        image = Image.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Image.any_instance.stub(:save).and_return(false)
        put :update, {:id => image.to_param, :image => { "name" => "invalid value" }, :cloud_server_id => @cloud_server.id}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested image" do
      image = Image.create! valid_attributes
      expect {
        delete :destroy, {:id => image.to_param, :cloud_server_id => @cloud_server.id}
      }.to change(Image, :count).by(-1)
    end

    it "redirects to the images list" do
      image = Image.create! valid_attributes
      delete :destroy, {:id => image.to_param, :cloud_server_id => @cloud_server.id}
      response.should redirect_to(cloud_server_images_path)
    end
  end
  end

  context "as an user" do
    before do
      @user = FactoryGirl.build(:user, :approved => true)
      @user.confirm!
      @user.save
      sign_in @user
      @cloud_server = FactoryGirl.build(:cloud_server, :username => 'adan', :password => 'cambiame', :url => 'http://nube.inf.um.es:5000/v2.0/')
      @cloud_server.save
    end

    describe "get show" do
      it "assign the image to @image" do
        image = Image.create! valid_attributes
        get :show, {:id => image.to_param, :cloud_server_id => @cloud_server.id}
        expect(response).to_not be_success
      end
    end

    describe "GET index" do
      it "get an unauthorized error" do
        get 'index', :cloud_server_id => @cloud_server.id
        expect(response).to_not be_success
      end
    end

    describe "GET new" do
      it "get an unauthorized error" do
        get :new, :cloud_server_id => @cloud_server.id
        expect(response).to_not be_success
      end
    end

    describe "GET edit" do
      it "get an unauthorized error" do
        image = Image.create! valid_attributes
        get :edit, {:id => image.to_param, :cloud_server_id => @cloud_server.id}
        expect(response).to_not be_success
      end
    end

    describe "POST create" do
      it "get an unauthorized error" do
        post :create, {:image => valid_attributes, :cloud_server_id => @cloud_server.id}
        expect(response).to_not be_success
      end
    end


  end

end
