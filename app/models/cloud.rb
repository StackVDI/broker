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
  #:user_data=>"I2Nsb3VkLWNvbmZpZw0KaG9zdG5hbWU6IG15bm9kZQ=="
    os.create_server(:name  => args[:name], :imageRef => getimage(args[:image]), :flavorRef => getflavor(args[:flavor]))
  end

  def destroy_server!(name)
    server(getserver(name)).delete!
  end

  def associate_ip_to_server(server)
    addr = os.create_floating_ip
    sleeping(5).seconds.between_tries.failing_after(10).tries {
      os.attach_floating_ip({:server_id => server.id , :ip_id => addr.id })
    }
    addr.ip
  end

  def unpause(server_name)
    os.server(getserver(server_name)).unpause
  end

  def pause(server_name)
    os.server(getserver(server_name)).pause
  end

end
