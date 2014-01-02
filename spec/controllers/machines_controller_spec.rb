require 'spec_helper'

describe MachinesController do

  before do
    @user = FactoryGirl.build(:user, :approved => true)
    #@user.add_role :admin
    @user.confirm!
    @user.save
    sign_in @user
    @image = FactoryGirl.create(:image)
    @image.roles << @user.roles
    @image.save
  end


  describe "get create" do
      it "creates a new machine" do
        expect {
          get :create, {:id => 1}
        }.to change(Machine, :count).by(1)
      end

      it "assigns a newly created machine as @machine" do
        get :create, {:id => @image.id}
        assigns(:machine).should be_a(Machine)
        assigns(:machine).should be_persisted
      end

      it "redirects to the created machine" do
        get :create, {:id => @image.id}
        @machine = Machine.last
        response.should redirect_to machine_path(@machine)
      end
  end

end
