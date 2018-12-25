module UsersHelper
  def current_user?(user)
    if current_user == user
      true
    else
      false
    end
  end
end
