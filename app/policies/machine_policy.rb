class MachinePolicy 

  attr_reader :user, :machine

  def initialize(user, machine)
    @user = user
    @machine = machine
  end

  def index?
    user.admin?
  end

  def show?
    user.admin? || machine.user == user 
  end

  def create?
    user.machines.count < 3
  end

  def destroy?
    user.admin? || machine.user == user 
  end

  def reboot?
    user.admin? || machine.user == user
  end

end 
