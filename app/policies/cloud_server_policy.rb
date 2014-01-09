class CloudServerPolicy 

  attr_reader :user, :cloud_server

  def initialize(user, cloud_server)
    @user = user
    @cloud_server = cloud_server
  end

  def index?
    user.admin?
  end

  def show?
    user.admin?
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
