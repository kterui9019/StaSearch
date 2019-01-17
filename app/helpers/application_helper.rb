module ApplicationHelper
  def access_info(accesses)
    if accesses&.count > 1
      return accesses.first.name + " ほか" + (accesses.count - 1).to_s + "駅"
    else
      return accesses.first.name
    end
  end
end
