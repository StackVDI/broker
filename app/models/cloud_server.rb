class CloudServer < ActiveRecord::Base
  has_many :images

  def connect
    @os = Cloud.new({
      :username => username,
      :auth_method => 'password',
      :api_key => password,
      :auth_url => url
    }) 
  end

  def os
    @os
  end

  def machines
    begin
      @os ||= connect
      @os.images
    rescue
      []
    end
  end

  def flavors
    begin
      @os ||= connect
      @os.flavors
    rescue
      []
    end
  end

  def create_server(args)
      @os ||= connect
      @os.create_server(:name => args[:name], :image => args[:image], :flavor => args[:flavor], :password => args[:password])
  end

  def pause(name)
    @os ||= connect
    @os.pause name 
  end
  
  def unpause(name)
    @os ||= connect
    @os.unpause name
  end

  def destroy_server(name)
    status = Timeout::timeout(5) {
      @os ||= connect
      @os.destroy_server! name
    }
  end
  
  def reboot(name)
    @os ||= connect
    @os.reboot! name
  end

  def ip(name)
    @os ||= connect
    @os.ip name
  end

end
