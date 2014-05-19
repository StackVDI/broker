class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :machines

  after_create :set_default_role

  def set_default_role
    self.add_role(:default)
  end

 
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  def active_for_authentication? 
    super && approved? 
  end 

  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end 

  def admin?
    has_role? :admin
  end

  def self.admins
    User.with_role(:admin)
  end

  def approve!
    self.approved=true
  end

  def toggle_approved!
    self.approved = !self.approved
  end

  def images_available
    images_disponibles = []
    self.roles.each do |role| 
      role.images.each do |image| 
        images_disponibles << image
      end
    end
    images_disponibles.uniq 
  end

  def max_lifetime
    max = -1
    roles.each do |rol|
      if rol.machine_lifetime == 0 
        return 0
      elsif rol.machine_lifetime > max
        max = rol.machine_lifetime
      end 
    end
    max
  end

  def max_idletime
    max = -1
    roles.each do |rol|
      if rol.machine_idletime == 0 
        return 0
      elsif rol.machine_idletime > max
        max = rol.machine_idletime
      end 
    end
    max
  end

end
