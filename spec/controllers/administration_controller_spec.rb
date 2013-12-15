require 'spec_helper'

describe AdministrationController do

  context 'login as an admin' do
    before do
      @user = FactoryGirl.build(:user)
      @user = FactoryGirl.build(:user, :approved => true)
      @user.add_role :admin
      @user.confirm!
      @user.save
      sign_in @user
      @raul = FactoryGirl.create(:user, :name => 'Raul')
      @alex = FactoryGirl.create(:user, :name => 'Alex')
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
        expect(assigns(:groups)).to match_array([Role.first])
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
  end



  context 'login as an user' do
    before do
      @user = FactoryGirl.build(:user)
      @user = FactoryGirl.build(:user, :approved => true)
      @user.confirm!
      @user.save
      sign_in @user
    end

    describe "GET 'list_users'" do
      it "returns http success" do
        get 'list_users'
        response.should_not be_success
      end
    end
  end


end
