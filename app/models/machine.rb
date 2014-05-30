class Machine < ActiveRecord::Base
  belongs_to :image
  belongs_to :user

  scope :paused, ->(image) { where("image_id = ? and user_id is null", image) }

  def self.launch(image)
    # TODO: Crear usuario, clave, ip y puerto 
    clave = (0...16).map { ('a'..'z').to_a[rand(26)] }.join
    machine = Machine.new(:image => image, :remote_username => "openvdi", :remote_password => clave )
  
    ready_machine = Machine.paused(image.id).first
    return machine, ready_machine
  end

  def cloud_server
    self.image.cloud_server
  end

  def cloud_create
     self.cloud_server.create_server(:name => "openvdi" + self.id.to_s, :image => self.image.machine, :flavor => self.image.flavor, :password => self.remote_password)
  end

  def cloud_destroy
    self.cloud_server.destroy_server("openvdi" + self.id.to_s)
  end

  def unpause
    self.cloud_server.unpause("openvdi" + self.id.to_s)
  end

  def pause
    self.cloud_server.pause("openvdi" + self.id.to_s)
  end

  def reboot
    self.cloud_server.reboot("openvdi" + self.id.to_s)
  end

  def ip
    self.cloud_server.ip("openvdi" + self.id.to_s)
  end

  def must_destroy?
    max_lifetime_expired || max_idletime_expired
  end

  def max_lifetime_expired
    if user 
      if user.max_lifetime == 0
        false
      else
        Time.now > updated_at.to_time + user.max_lifetime.hours
      end
    else
      false
    end
  end

  def max_idletime_expired
    if user 
      if user.max_idletime == 0
        false
      else
        Time.now > user.current_sign_in_at + user.max_idletime.hours
      end
    else
      false
    end
  end

  def self.check_expired
    Machine.all.each do |maquina|
      if maquina.must_destroy? 
        puts "Destroying Machine #{maquina.id}. Owner: #{maquina.user.email}"
        begin
          maquina.cloud_destroy
        rescue Timeout::Error || TypeError || Errno::ECONNREFUSED
          maquina.destroy
        else
          maquina.destroy
        end
      end
    end
  end
end
