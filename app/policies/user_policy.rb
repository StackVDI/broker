class UserPolicy 

  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def delete_user?
    last_admin = false
    if @user.has_role(:admin) && User.admins.size == 1
      last_admin = true
    end
    current_user.admin? && !last_admin
  end

end
