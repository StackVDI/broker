require 'spec_helper'

describe User do

  it { should validate_presence_of(:name)}

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

end
