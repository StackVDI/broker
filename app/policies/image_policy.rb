class ImagePolicy 

  attr_reader :user, :image

  def initialize(user, image)
    @user = user
    @image = image
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
