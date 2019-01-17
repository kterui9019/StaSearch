module StudiosHelper
  def show_current_number(current_page,size)
    if size > 8
      first = 1
      last  = size
      last *= current_page
      first = last -8
      return "#{first} ~ #{last}"
    else
      return "1 ~ #{size}"
    end
  end
  
  def rating(reviews)
    rate = 0.0
    if reviews.any?
      reviews.each { |review| rate += review.rate.to_f }
      rate /= reviews.count
    end
    return rate.round(2)
  end
  
  def show_search_words(words)
    ary = []
    words.each { |word| ary.push word[:name_or_address_cont] }
    ary.join(" ")
  end
  
  def line_info(access)
    if access&.line.include?("ほか")
      return access&.line.slice(0..-3)
    else
      return access&.line
    end
  end
end
