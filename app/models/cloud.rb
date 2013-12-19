class Cloud
  include Anticipate

  attr_reader :os 
  
  def initialize(params)
    @os = OpenStack::Connection.create({
      :username => params[:username],
      :auth_method => params[:auth_method],
      :api_key => params[:password],
      :auth_url => params[:auth_url]
    })        
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

  def getcloudinit(args)
  end

  def create_server(args)
  #:user_data=>"I2Nsb3VkLWNvbmZpZw0KaG9zdG5hbWU6IG15bm9kZQ=="
    os.create_server(:name  => args[:name], :imageRef => getimage(args[:image]), :flavorRef => getflavor(args[:flavor]))
  end

  def associate_ip_to_server(server)
    addr = os.create_floating_ip
    sleeping(5).seconds.between_tries.failing_after(10).tries {
      os.attach_floating_ip({:server_id => server.id , :ip_id => addr.id })
    }
    addr.ip
  end

end
