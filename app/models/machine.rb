class Machine < ActiveRecord::Base
  belongs_to :user
  belongs_to :image

  validates :remote_username, :presence => :true
  validates :remote_password, :presence => :true
end
