class Machine < ActiveRecord::Base
  belongs_to :image
  belongs_to :user

  scope :paused, ->(image) { where("image_id = ? and user_id is null", image) }

  def self.launch(image)
    # TODO: Crear usuario, clave, ip y puerto 
    machine = Machine.new(:image => image)
    ready_machine = Machine.paused(image.id).first
    return machine, ready_machine
  end

  def cloud_server
    self.image.cloud_server
  end

  def cloud_create
     self.cloud_server.create_server(:name => self.id.to_s, :image => self.image.machine, :flavor => self.image.flavor)
  end

  def cloud_destroy
    self.cloud_server.destroy_server(self.id.to_s)
  end

  def unpause
    self.cloud_server.unpause(self.id.to_s)
  end

  def pause
    self.cloud_server.pause(self.id.to_s)
  end

  def reboot
    self.cloud_server.reboot(self.id.to_s)
  end

end
