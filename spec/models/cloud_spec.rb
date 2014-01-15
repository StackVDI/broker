require 'spec_helper'

describe '@cloud' do
  before do
    VCR.use_cassette('openstack_connection') do
      @cloud = Cloud.new(username: 'adan', api_key: 'cambiame',  auth_method: "password", auth_url: "http://nube.inf.um.es:5000/v2.0/")
    end
  end

  describe '.flavors' do
    it 'returns all the flavors' do
      VCR.use_cassette('flavors') do
        expect(@cloud.flavors.size).to be == 6
      end
    end
  end
    
  describe '.getflavor' do
    it 'returns the id of a flavor' do
      VCR.use_cassette('get_flavor_1') do
        expect(@cloud.getflavor("m1.medium")).to eq "0241420c-5330-4b26-8d65-1cf67dad45e3"
      end
    end
    it 'returns the id of a flavor' do
      VCR.use_cassette('get_flavor_2') do
        expect(@cloud.getflavor("m1.tiny")).to eq "1"
      end
    end
  end

  describe '.images' do
    it 'returns all the images' do
      VCR.use_cassette('images') do
        expect(@cloud.images.size).to be == 2
      end
    end
  end

  describe '.getimage' do
    it 'returns the id of an image' do
      VCR.use_cassette('get_image_1') do
        expect(@cloud.getimage("ubuntu_server_12_04_x64")).to eq "c7818c6a-0868-4af7-af7e-6b8c55e1688d"
      end
    end
  end

  describe '.create_server' do
    it 'create a server' do
      VCR.use_cassette('create_server') do
        newserver = @cloud.create_server( :name  => "New Server", 
                                         :image => "ubuntu_server_12_04_x64", 
                                         :flavor => "m1.medium",
                                         :username => "username1",
                                         :password => "password2")
        expect(newserver.status).to eq "BUILD"
      end
    end
  end

  describe '.associate_ip_to_server' do
    it 'returns the new floating ip of the server' do
      VCR.use_cassette('floating_ip') do
        server = @cloud.create_server( :name  => "New Server", 
                                :image => "ubuntu_server_12_04_x64", 
                                :flavor => "m1.medium")
        expect(@cloud.associate_ip_to_server(server)).to eq "155.54.225.153"
      end
    end
  end

  describe '.unpause' do
    it 'unpause server' do
      @server = double
      @server.stub(:name).and_return("unpause")
      @server.stub(:unpause)
      @cloud.stub(:getserver)
      @cloud.os.stub(:server).and_return(@server)
      @server.should_receive(:unpause)
      @cloud.unpause("unpause")
    end
  end
  
  describe '.pause' do
    it 'pause server' do
      @server = double
      @server.stub(:name).and_return("pause")
      @server.stub(:pause)
      @cloud.stub(:getserver)
      @cloud.os.stub(:server).and_return(@server)
      @server.should_receive(:pause)
      @cloud.pause("pause")
    end
  end

  describe '.reboot' do
    it 'reboot a server' do
      @server = double
      @server.stub(:name).and_return("reboot")
      @server.stub(:pause)
      @cloud.stub(:getserver)
      @cloud.os.stub(:server).and_return(@server)
      @server.should_receive(:reboot)
      @cloud.reboot!("reboot")
    end
  end

end
