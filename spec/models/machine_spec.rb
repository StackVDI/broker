require 'spec_helper'

describe Machine do

  it { should belong_to(:image) }
  it { should belong_to(:user) }

  before do
    @image = FactoryGirl.create(:image)      
    @machine = FactoryGirl.create(:machine, :image => @image)
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

  describe 'cloud_server' do
    it 'returns image.cloud_server' do
      @machine.cloud_server.should == @machine.image.cloud_server
    end
  end 

  describe 'cloud_create' do
    describe 'launch a machine in the cloud server' do
      it 'call machine.cloud_server.create_server' do
        CloudServer.any_instance.stub(:create_server)
        @machine.cloud_server.should_receive(:create_server)
        @machine.cloud_create
      end
    end
  end

  describe 'cloud_destroy' do
    describe ' destroy a running machine in the cloud_server' do
      it 'call machine.cloud_server reboot' do
        CloudServer.any_instance.stub(:reboot)   
        @machine.cloud_server.should_receive(:reboot).with(@machine.id.to_s).and_return("")
        @machine.reboot
      end
    end
  end

  describe 'pause' do
    it 'call machine.cloud_server pause' do
      CloudServer.any_instance.stub(:pause)   
      @machine.cloud_server.should_receive(:pause).with(@machine.id.to_s)  
      @machine.pause
    end
  end

  describe 'unpause' do
    it 'call machine.cloud_server unpause' do
      CloudServer.any_instance.stub(:unpause)   
      @machine.cloud_server.should_receive(:unpause).with(@machine.id.to_s)  
      @machine.unpause
    end
  end

  describe 'reboot' do
    it 'call machine.cloud_server reboot' do
      CloudServer.any_instance.stub(:reboot)   
      @machine.cloud_server.should_receive(:reboot).with(@machine.id.to_s).and_return("")
      @machine.reboot
    end
  end

end
