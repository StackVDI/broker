class Cloud
  include Anticipate

  attr_reader :os 
  
  def initialize(params)
    @os = OpenStack::Connection.create(params)
  end

  def flavors
    os.flavors
  end

  def getflavor(name)
    flavors[flavors.index { |x| x[:name] == name }][:id] 
  end


  def images
    os.images
  end

  def getimage(name)
    images[images.index { |x| x[:name] == name }][:id]
  end

  def servers
    os.servers
  end

  def server(id)
    os.server(id)
  end

  def getserver(name)
    servers[servers.index { |x| x[:name] == name }][:id]  
  end

  def create_server(args)
    user_data =  Base64.encode64("#cloud-config\npassword: #{args[:password]}\nchpasswd: { expire: False }\nssh_pwauth: True\n")
    os.create_server(:name  => args[:name], :imageRef => getimage(args[:image]), :flavorRef => getflavor(args[:flavor]), :user_data => user_data, :networks => [:uuid => "471a8717-c995-44b6-a5ec-1b7e4ebf7285"] )
  end

  def destroy_server!(name)
    server(getserver(name)).delete!
  end

  def associate_ip_to_server(server_name)
    server = getserver(server_name)
    ips = os.get_floating_ips
    sleeping(10).seconds.between_tries.failing_after(20).tries {
      addr = ips.select { |ip|  ip.instance_id == nil}.sample
      ips = ips - [addr]
      puts "\nIntento con la ip #{addr.ip} en #{server_name}\n\n"
      os.attach_floating_ip({:server_id => server , :ip_id => addr.id })
      addr.ip
    }
  end

  def unpause(server_name)
    os.server(getserver(server_name)).unpause
  end

  def pause(server_name)
    os.server(getserver(server_name)).pause
  end

  def reboot!(server_name)
    os.server(getserver(server_name)).reboot
  end

  def ip(server_name)
    os.server(getserver(server_name)).addresses.first.address
  end


end
