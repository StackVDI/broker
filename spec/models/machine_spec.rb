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
        @machine.cloud_server.should_receive(:reboot).with("openvdi" + @machine.id.to_s).and_return("")
        @machine.reboot
      end
    end
  end

  describe 'pause' do
    it 'call machine.cloud_server pause' do
      CloudServer.any_instance.stub(:pause)   
      @machine.cloud_server.should_receive(:pause).with("openvdi" + @machine.id.to_s)  
      @machine.pause
    end
  end

  describe 'unpause' do
    it 'call machine.cloud_server unpause' do
      CloudServer.any_instance.stub(:unpause)   
      @machine.cloud_server.should_receive(:unpause).with("openvdi" + @machine.id.to_s)  
      @machine.unpause
    end
  end

  describe 'reboot' do
    it 'call machine.cloud_server reboot' do
      CloudServer.any_instance.stub(:reboot)   
      @machine.cloud_server.should_receive(:reboot).with("openvdi" + @machine.id.to_s).and_return("")
      @machine.reboot
    end
  end

  describe 'must_destroy?' do
    describe 'check machine lifetime and machine idletime' do
      it 'is true when max lifetime is expired' do
        @machine.stub(:max_lifetime_expired).and_return(true)
        @machine.should be_must_destroy
      end
      it 'is true when max idletime is expired' do
        @machine.stub(:max_lifetime_expired)
        @machine.stub(:max_idletime_expired).and_return(true)
        @machine.should be_must_destroy
      end
      it 'is false if doesnt belongs to any user' do
        @machine.stub(:user).and_return(false)
        @machine.should_not be_must_destroy
      end
      it 'is false when max_liteftime and max_idletime are false' do
        @machine.stub(:max_lifetime_expired).and_return(false)
        @machine.stub(:max_idletime_expired).and_return(false)
        @machine.should_not be_must_destroy
      end
    end
  end

  describe 'max_lifetime_expired' do
    describe 'check if machine lifetime is expired' do
      it 'With 23hours machine live a day ' do
        @time_now = Time.parse("May 27 1975")
        Time.stub(:now).and_return(@time_now)
        @machine.stub(:user).and_return(@user)
        @machine.user.stub(:max_lifetime).and_return(23)
        @machine.stub(:updated_at).and_return(Time.parse("May 26 1975"))
        @machine.max_lifetime_expired.should be_true
      end

      it 'With 0hours machine doesnt expire' do
        @machine.stub(:user).and_return(@user)
        @machine.user.stub(:max_lifetime).and_return(0)
        @machine.max_lifetime_expired.should be_false
      end
    end
  end

  describe 'max_idletime_expired' do
    describe 'check if machine idletime is expired' do
      it 'With 23hours machine live a day from last user sign_in ' do
        @time_now = Time.parse("May 27 1975")
        Time.stub(:now).and_return(@time_now)
        @machine.stub(:user).and_return(@user)
        @machine.user.stub(:max_idletime).and_return(23)
        @machine.user.stub(:current_sign_in_at).and_return(Time.parse("May 26 1975"))
        @machine.max_idletime_expired.should be_true
      end

      it 'With 0hours machine doesnt expire' do
        @machine.stub(:user).and_return(@user)
        @machine.user.stub(:max_idletime).and_return(0)
        @machine.max_idletime_expired.should be_false
      end
    end
  end

end
