class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  has_and_belongs_to_many :images, :join_table => :images_roles
  belongs_to :resource, :polymorphic => true
  
  validates :machine_idletime, presence: true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :machine_lifetime, presence: true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :concurrent_machines, presence: true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }
  
  scopify
end
