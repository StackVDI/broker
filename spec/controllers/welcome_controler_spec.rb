require 'spec_helper'

describe WelcomeController do
  
  context "User logged" do
    before do
      @user = FactoryGirl.build(:user, :approved => true)
      @user.add_role :primero
      @user.confirm!
      @user.save
      sign_in @user
    end

    describe ".index" do
      it "returns http success" do
        get 'index'
        expect(response).to be_success
      end
      it "assigns all available images to @available_images" do
        image = FactoryGirl.create(:image)
        image.roles << Role.find_by_name(:primero)
        image.save
        get :index
        assigns(:available_images).should eq([image])
      end
    end
  end

  context "User not logged" do
    describe ".index" do
      it "returns http success" do
        get 'index'
        expect(response).to_not be_success
      end
    end
  end

end


