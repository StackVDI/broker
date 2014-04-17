class Image < ActiveRecord::Base
  has_and_belongs_to_many :roles, :join_table => :images_roles
  belongs_to :cloud_server
  has_many :machines

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "50x50>" }, :default_url => "/images/:style/missing.png"

  validates :name, :presence => true
  validates :description, :presence => true
  validates_presence_of :cloud_server
  validates_presence_of :machine
  validates_presence_of :flavor
  validates_presence_of :number_of_instances
  validates_numericality_of :number_of_instances, only_integer: true, greater_than: 0


  def self.prelaunch
    Image.all.each do |image|
      (image.number_of_instances - Machine.paused(image.id).count).times do
        machine = Machine.create(:image => image)
        StartMachine.perform_async(machine.id)
      end
    end
  end
end
