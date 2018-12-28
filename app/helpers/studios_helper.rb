module StudiosHelper
  def show_current_number(current_page,size)
    first = 1
    last  = size
    last *= current_page
    first = last -8
    return "#{first} ~ #{last}"
  end
end
