class RolePolicy 

  attr_reader :user, :role

  def initialize(user, role)
    @user = user
    @role = role
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

end
