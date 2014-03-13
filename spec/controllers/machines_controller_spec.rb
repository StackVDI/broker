require 'spec_helper'

describe MachinesController do

    context "as admin" do
      before do
        @user = FactoryGirl.build(:user, :approved => true)
        @user.add_role :admin
        @user.confirm!
        @user.save
        sign_in @user
      end
 
      describe "GET index" do
        it "assigns all machines as @machines" do
          machine = FactoryGirl.create(:machine)
          machine.save
          get :index
          assigns(:machines).should eq([machine])
        end
      end
  
      describe "GET show" do
        it "assigns the requested machine as @machine if machine belongs to the user" do
          machine = FactoryGirl.create(:machine)
          get :show, {:id => machine.id}
          assigns(:machine).should eq(machine)
        end
      end

      describe "GET reboot" do
        it "reboots a machine" do
          Machine.any_instance.stub(:reboot)
          machine = FactoryGirl.create(:machine)
          get :reboot, {:id => machine.id}
          response.should redirect_to root_path
        end
      end
    end

    context "as user" do
      before do
        @user = FactoryGirl.build(:user, :approved => true)
        @user.confirm!
        @user.save
        sign_in @user
      end

      describe "GET index" do
        it "get an unauthorized error" do
         get :index
          expect(response).to_not be_success
        end
      end

      describe "GET show" do
        it "assigns the requested machine as @machine if machine belongs to the user" do
          machine = FactoryGirl.create(:machine, :user => @user)
          get :show, {:id => machine.id}
          assigns(:machine).should eq(machine)
        end
        it "return an unauthorized error if the requested machine doesn't belongs to the user" do
          machine = FactoryGirl.create(:machine)
          get :show, {:id => machine.id}
          expect(response).to_not be_success
        end
      end

      describe "POST create" do
        before do
          Machine.any_instance.stub(:cloud_create)
          Machine.any_instance.stub(:pause)
          Machine.any_instance.stub(:unpause)
          @image = FactoryGirl.create(:image)
          @machine = FactoryGirl.create(:machine, :image => @image, :user => nil)
        end

        it "creates a new Machine" do
         expect {
            post :create, {:id => @image.id}
          }.to change(Machine, :count).by(1)
        end

        it "user has a new machine assigned" do
         expect {
            post :create, { :id => @image.id }
          }.to change(@user.machines, :count).by(1)
        end

        it "redirects to a paused machine" do
          post :create, { :id => @image.id }
          response.should redirect_to(@machine)
        end
      end

    describe "DELETE destroy" do
      it "destroys the requested machine" do
        machine = FactoryGirl.create(:machine, :user => @user)
        Machine.any_instance.stub(:cloud_destroy)
        expect {
          delete :destroy, {:id => machine.id}
        }.to change(Machine, :count).by(-1)
      end

      it "rescue timeout error" do
        machine = FactoryGirl.create(:machine, :user => @user)
        Machine.any_instance.stub(:cloud_destroy).and_raise(Timeout::Error)
        delete :destroy, {:id => machine.id}
        flash[:notice].should eq("Machine has been deleted from database, but there is no connection with cloud. YOU SHOULD DELETE THIS VM MANUALLY FROM THE CLOUD. Reason: Timeout::Error. Cloud Server Description - 1")
      end

      it "rescue type error" do
        machine = FactoryGirl.create(:machine, :user => @user)
        Machine.any_instance.stub(:cloud_destroy).and_raise(TypeError)
        delete :destroy, {:id => machine.id}
        flash[:notice].should eq("Machine has been deleted from database, but there isn't a machine with id 1 in Cloud Server Description")
      end

      it "rescue connection refused" do
        machine = FactoryGirl.create(:machine, :user => @user)
        Machine.any_instance.stub(:cloud_destroy).and_raise(Errno::ECONNREFUSED)
        delete :destroy, {:id => machine.id}
        flash[:notice].should eq("Machine has been deleted from database, but there is no connection with cloud. YOU SHOULD DELETE THIS VM MANUALLY FROM THE CLOUD. Reason: Connection refused. Cloud Server Description - 1")
      end
    end
  end
end
