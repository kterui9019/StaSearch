areas=["新宿","渋谷","池袋","秋葉原"]
tags =['#料金が安い', '#設備がキレイ', '#エフェクターレンタル可','#待合室が広い','#wi-fi有', '#24時間営業']

areas.each do |area|
  Area.create!(name: area)
end

tags.each do |tag|
  HashTag.create!(tag: tag)
end

User.create!(
              name:"foobar",
              email:"foo@bar",
              password:"foobar")

30.times do |n|
  name = "スタジオ" + Takarabako.open
  area_id = Random.rand(1..4)
  Studio.create!(
                name: name,
                area_id: area_id,
                image: "default-studio-icon.jpeg",
                address: "東京都新宿区西新宿２丁目８−１",
                telno: "000-0000-0000",
                url: "http://www.testtest.com")
end

=begin
uri = URI.parse URI.encode "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?inputtype=textquery&input=牛角&language=ja&fields=id&key=#{ENV['GOOGLEMAPS_IP_KEY']}"
res = HTTP.get(uri).to_s
response = JSON.parse(res)
=end
