class Image < ActiveRecord::Base
  has_and_belongs_to_many :roles, :join_table => :images_roles
  belongs_to :cloud_server

  validates :name, :presence => true
  validates :description, :presence => true
  validates_presence_of :cloud_server
  validates_presence_of :machine
  validates_presence_of :flavor
  validates_presence_of :number_of_instances
  validates_numericality_of :number_of_instances, only_integer: true, greater_than: 0
end
