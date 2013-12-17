require 'spec_helper'

describe RolesController do

  before do
    @rol = FactoryGirl.build(:role)
    @rol.save
  end

  context 'login as an admin' do
    before do
      @user = FactoryGirl.build(:user, :approved => true)
      @user.add_role :admin
      @user.confirm!
      @user.save
      sign_in @user
        end

    describe '.new' do
      it "returns http success" do
          get 'new'
          expect(response).to be_success
        end

        it "renders the new view " do
          get 'new'
          expect(response).to render_template :new
        end
    end

    describe '.create' do
        
      it 'creates a new Role' do
        expect {
          post :create, role: { name: 'Test Role' }
        }.to change(Role, :count).by(1)
      end

      it 'assigns a new Role' do
        post :create, role: {name: 'Test Role'}
        assigns(:role).should be_a(Role)
        assigns(:role).should be_persisted
      end
    end

    describe '.edit' do
      it "returns http success" do
          get 'edit', id: @rol
          expect(response).to be_success
        end

        it "renders the edit view " do
          get 'edit', id: @rol
          expect(response).to render_template :edit
        end
    end

    describe '.update' do
      it "returns http success" do
        patch 'update', id: @rol, role: { name: 'rol2' }
        expect(response).to redirect_to administration_list_groups_path
      end

      it "updates the rol name" do
        patch 'update', id: @rol, role: { name: 'rol2' }
        assigns(:role).name.should be == 'rol2'
      end
    end

    describe '.destroy' do
      it 'destroy a Role' do
        expect {
          delete :destroy, id: @rol
        }.to change(Role, :count).by(-1)
      end
    end

  end


  context 'login as an user' do
    before do
      @user = FactoryGirl.build(:user, :approved => true)
      @user.confirm!
      @user.save
      sign_in @user
    end

      it "can not get /new" do
        get 'new'
        expect(response).to_not be_success
      end
    
    it 'can not post /create' do
      post :create, role: { name: 'Test Role' }
      expect(response).to_not be_success
    end

    it 'can not get /edit' do
      get :edit, id: @rol.id
      expect(response).to_not be_success
    end

    it 'can not put /update' do
      patch :update, id: @rol.id, role: { name: 'rol2'}
      expect(response).to_not be_success
    end

    it 'can not destroy a rol' do
      expect {
        delete :destroy, id: @rol
      }.to_not change(Role, :count).by(-1)
    end

  end

end
