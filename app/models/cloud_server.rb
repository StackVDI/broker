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

end
