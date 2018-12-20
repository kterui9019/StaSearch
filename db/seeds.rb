areas=["新宿","渋谷","池袋","秋葉原"]

areas.each do |area|
  Area.create!(name: area)
end


100.times do |n|
  name = "スタジオ" + Takarabako.open
  area_id = Random.rand(1..4)
  Studio.create!(name: name,
               area_id: area_id
               )
end