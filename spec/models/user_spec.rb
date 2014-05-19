require 'spec_helper'

describe User do

  it { should validate_presence_of(:first_name)}
  it { should validate_presence_of(:last_name)}


  describe 'set_default_group' do 
    it 'is in default group after create' do
      user = FactoryGirl.create(:user)
      user.has_role?(:default).should be true
    end
  end
  describe '.admin?' do
    it 'user is not admin by default' do
      User.new.admin?.should be_false
    end
    it 'true if has admin role' do
      user = FactoryGirl.build(:user)
      user.add_role :admin
      user.admin?.should be_true
    end
  end

  describe '.aprove!' do
    it 'sets aproved property to true' do
      user = FactoryGirl.build(:user)
      user.approved?.should be_false
      user.approve!
      user.approved?.should be_true
    end
  end

  describe '.toggle_approved!' do
    it 'toggle approved value' do
      user = FactoryGirl.build(:user)
      expect{
        user.toggle_approved!
      }.to change{user.approved?}
    end
  end

  describe '.images_available' do
    it 'returns images available for the user' do
      user = FactoryGirl.build(:user)
      role = FactoryGirl.build(:role, :name => 'primero')
      user.roles << role
      image = FactoryGirl.build(:image)
      image.roles << role
      user.save
      role.save
      image.save
      user.images_available.should == [image]
    end
  end

  describe '#admins' do
    it 'returns admin users' do
      user = FactoryGirl.create(:user)
      user.add_role(:admin)
      User.admins.should == [user]
      user2 = FactoryGirl.create(:user)
      user2.add_role(:admin)
      User.admins.should == [user,user2]
    end
  end

  describe '.max_lifetime' do
    before do
      @user = FactoryGirl.build(:user)
      role = FactoryGirl.build(:role, :name => 'primero', :machine_lifetime => '23')
      @role2 = FactoryGirl.build(:role, :name => 'segundo', :machine_lifetime => '0')
      @user.roles << role
    end
    it 'returns max lifetime of all groups of a user' do
      @user.max_lifetime.should == 23
    end
    it 'returns 0 if anyone is 0' do
      @user.roles << @role2
      @user.max_lifetime.should == 0
    end
    it 'returns -1 if no rol assigned to user' do
      user = FactoryGirl.build(:user)
      user.max_lifetime.should == -1
    end
  end


  describe '.max_idletime' do
    before do
      @user = FactoryGirl.build(:user)
      role = FactoryGirl.build(:role, :name => 'primero', :machine_idletime => '23')
      @role2 = FactoryGirl.build(:role, :name => 'segundo', :machine_idletime => '0')
      @user.roles << role
    end
    it 'returns max idletime of all groups of a user' do
      @user.max_idletime.should == 23
    end
    it 'returns 0 if anyone is 0' do
      @user.roles << @role2
      @user.max_idletime.should == 0
    end
    it 'returns -1 if no rol assigned to user' do
      user = FactoryGirl.build(:user)
      user.max_idletime.should == -1
    end
  end

end
