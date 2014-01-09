require 'spec_helper'

describe Machine do

  before do
    @image = FactoryGirl.create(:image)      
    @user = FactoryGirl.create(:user)
    Image.prelaunch
  end

  describe 'launch' do
    it 'return two images' do
      Machine.any_instance.stub(:unpause).and_return(:true) 
      @machine, @ready_machine = Machine.launch(@image)
      @machine.should be_an_instance_of  Machine
      @ready_machine.should be_an_instance_of Machine
    end
  end

  describe 'reboot' do
    pending
  end

end
