  require 'spec_helper'

describe AdministrationController do

  context 'login as an admin' do
    before do
      @user = FactoryGirl.build(:user, :approved => true)
      @user.add_role :admin
      @user.confirm!
      @user.save
      sign_in @user
      @raul = FactoryGirl.create(:user, :first_name => 'Raul')
      @alex = FactoryGirl.create(:user, :first_name => 'Alex')
      @raul.save
      @alex.save
    end

    describe "GET 'list_users'" do
      it "returns http success" do
        get 'list_users'
        expect(response).to be_success
      end

      it "renders the list_users view " do
        get 'list_users'
        expect(response).to render_template :list_users
      end

      it "have all the users" do
        get :list_users
        expect(assigns(:users)).to match_array([@user, @raul, @alex])
      end
    end

    describe "GET 'list_groups'" do
      it "returns http success" do
        get 'list_groups'
        expect(response).to be_success
      end

      it "renders the list_group view " do
        get 'list_groups'
        expect(response).to render_template :list_groups
      end

      it "have all the groupss" do
        get :list_groups
        expect(assigns(:groups)).to match_array(Role.all)
      end
    end

    describe "GET 'users_from_group'" do
      it "returns http success" do
        get 'users_from_group', id: 1
        expect(response).to be_success
      end

      it "renders the users_from_group view " do
        get 'users_from_group', id:1
        expect(response).to render_template :users_from_group
      end

      it "have all the users" do
        get :users_from_group, id:1
        expect(assigns(:users)).to match_array([@user])
      end
    end

    describe "PUT 'toggle_approved_user'"do
      it "redirects to administration user_list" do
        patch :toggle_approved_user, id: @raul 
        expect(response).to redirect_to administration_list_users_path
      end

      it "It toggles approved user property" do
        expect{
        patch :toggle_approved_user, id: @raul
        @raul.reload
        }.to change{@raul.approved?}
      end

    end
    
    describe "GET 'edit_user'" do
      it "returns http success" do
        get 'edit_user', id: @alex
        response.should be_success
      end
    end

    describe "PUT 'update_user'" do
      it "returns http success" do
        put 'update_user', id: @alex, user: FactoryGirl.attributes_for(:user)
        response.should redirect_to administration_list_users_path
      end

      it "changes @user's attributes" do
        patch 'update_user', id: @alex, user: FactoryGirl.attributes_for(:user, first_name:'Antonio', last_name:'Sánchez')
        @alex.reload
        expect(@alex.first_name).to eq('Antonio')
        expect(@alex.last_name).to eq('Sánchez')
      end

      it "fails with blank first name" do
        patch 'update_user', id: @alex, user: FactoryGirl.attributes_for(:user, first_name:'', last_name:'Sánchez')
        @alex.reload
        expect(@alex.first_name).to eq('Alex')
        expect(@alex.last_name).to_not eq('Sánchez')
      end
    end

    describe "DELETE 'delete_user'" do
      it "delete an user" do
        expect {
          delete :delete_user, {:id => @alex}
        }.to change(User, :count).by(-1) 
      end

      it "can't delete las admin user" do
        expect {
          delete :delete_user, :id => @user
        }.to_not change(User, :count)
      end
    end

    describe "GET 'upload_csv'" do
      it "get 'upload_csv'" do
        get 'upload_csv'
        expect(response).to be_success
      end
    end

    describe "POST 'check_file'" do
      before do
        @file = fixture_file_upload('files/right.csv', 'text/csv')
      end

      it "can upload a CSV file" do
        post :check_file, :upload => @file
        response.should be_success
      end

      it "can't upload a CSV file if no file provided" do
        post :check_file, :upload => nil
        flash[:alert].should eq "No file provided, upload a right file!!"
      end
    end

    describe "GET 'create_users'" do
      describe "create users from temp file" do
        it "with file in session goes OK" do
          FactoryGirl.create(:role, :name => "role1")
          FactoryGirl.create(:role, :name => "role2")

          @file = fixture_file_upload('files/right.csv', 'text/csv')
          session[:my_file] = @file.path
          get :create_users       
          response.should be_success
        end
        it "fails without temp file in session" do
          session[:my_file] = nil
          get :create_users
          response.should redirect_to administration_upload_csv_path
        end
      end
    end    
  end

  context 'login as an user' do
    before do
      @user = FactoryGirl.build(:user, :approved => true)
      @user.confirm!
      @user.save
      sign_in @user
      @another = FactoryGirl.build(:user, :approved => true)
      @another.confirm!
      @another.save
    end

    describe "GET 'list_users'" do
      it "doesn't return http success" do
        get 'list_users'
        response.should_not be_success
      end
    end

    describe "GET 'edit_user'" do
      it "doesn't return http success" do
        get 'edit_user', id: @another
        response.should_not be_success
      end
    end

    describe "PUT 'update_user'" do
      it "doesn't return http success" do
        put 'update_user', id: @another
        response.should_not redirect_to administration_list_users_path
      end
    end

    describe "DELETE 'delete_user'" do
      it "can't delete an user" do
        delete :delete_user, {:id => @another}
        response.should_not be_success
      end
    end

    describe "GET 'upload_csv'" do
      it "doesn't return http success" do
        get 'upload_csv'
        response.should_not be_success
      end
    end
  end
end
