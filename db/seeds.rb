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

uri = URI.parse URI.encode "https://maps.googleapis.com/maps/api/place/textsearch/json?query=音楽スタジオ+新宿駅&language=ja&key=#{ENV['GOOGLEMAPS_IP_KEY']}"
res = HTTP.get(uri).to_s
response = JSON.parse(res)
response['results'].each do |result|
  
  studio = Studio.new(
                name: result['name'],
                area_id: 1,
                address: result['formatted_address'].slice(13..-1),
                latitude: result['geometry']['location']['lat'],
                longitude: result['geometry']['location']['lng'],
                telno: "000-0000-0000",
                url: "http://www.testtest.com",
                )
  if result.has_key?("photos")
    photo_reference = result['photos'][0]['photo_reference'] 
    url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=400&photoreference=#{photo_reference}&key=#{ENV['GOOGLEMAPS_IP_KEY']}"
    studio.remote_image_url = url
  end
  studio.save!
  
end