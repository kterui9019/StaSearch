module StudiosHelper
  def favorited?(user_id, studio_id)
    if Favorite.find_by(user_id: user_id, studio_id: studio_id)    
      return true
    else
      return false
    end
  end
end