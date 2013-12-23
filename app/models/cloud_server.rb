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
    @os ||= connect
    @os.images
  end

  def flavors
    @os ||= connect
    @os.flavors
  end

end
