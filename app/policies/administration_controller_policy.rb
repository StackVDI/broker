class AdministrationControllerPolicy 

  attr_reader :user, :ctrl

  def initialize(user, ctrl)
    @user = user
    @ctrl = ctrl
  end

  def list_users?
    user.admin?
  end

  def list_groups?
    user.admin?
  end

  def toggle_approved_user?
    user.admin?
  end

  def users_from_group?
    user.admin?
  end

  def edit_user?
    user.admin?
  end

  def update_user?
    user.admin?
  end

  def upload_csv?
    user.admin?
  end

  def check_file?
    user.admin?
  end

  def create_users?
    user.admin?
  end
end
