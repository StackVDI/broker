class Machine < ActiveRecord::Base
  belongs_to :image
  belongs_to :user

  scope :paused, ->(image) { where("image_id = ? and user_id is null", image) }

  def cloud_create
     self.image.cloud_server.create_server(:name => self.id.to_s, :image => self.image.machine, :flavor => self.image.flavor)
  end

  def cloud_destroy
    self.image.cloud_server.destroy_server(self.id.to_s)
  end

  def unpause
    self.image.cloud_server.unpause(self.id.to_s)
  end

  def pause
    self.image.cloud_server.pause(self.id.to_s)
  end

  def reboot
    self.image.cloud_server.reboot(self.id.to_s)
  end

  def self.launch(image)
    machine = Machine.new(:image => image)
    ready_machine = Machine.paused(image.id).first
    begin 
      ready_machine.unpause
    rescue
      ""
    end
    return machine, ready_machine
  end
end
