require 'spec_helper'

describe CloudServer do

  before do
    @cloud_server = FactoryGirl.create(:cloud_server)
    @cloud_server.stub(:connect)
  end

  it { should have_many(:images) }

  describe ".machines" do
    it "returns machines of the cloud server" do
      @cloud_server.os.should_receive(:images)
      @cloud_server.machines
    end
  end

  describe ".flavors" do
    it "returns flavors of the cloud server" do
      @cloud_server.os.should_receive(:flavors)
      @cloud_server.flavors
    end
  end

  describe "pause" do
    it "pauses a runnning machine in a cloud server" do
      @cloud_server.os.should_receive(:pause).with(:name)
      @cloud_server.pause :name
    end
    
  end

  describe "unpause" do
      it "unpauses a running machine in the cloud server" do
      @cloud_server.os.should_receive(:unpause).with(:name)
      @cloud_server.unpause :name
    end
  
  end

  describe "create_server" do
    it "create a new server in the cloud" do
      @cloud_server.os.should_receive(:create_server)
      @cloud_server.create_server({:name => "name", :image => "ubuntu", :flavor => "m1.tiny"})
    end
  end

  describe "destroy_server" do
    it "destroys a running machine of the cloud server" do
      @cloud_server.os.should_receive(:destroy_server!).with(:name)
      @cloud_server.destroy_server :name
    end
  end

  describe 'reboot' do
    it "reboots a running machine of the cloud server" do
      @cloud_server.os.should_receive(:reboot!).with(:name)
      @cloud_server.reboot :name
    end
  end

end 
