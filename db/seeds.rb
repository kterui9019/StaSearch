require "date"

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

locations = ["35.670812,139.754182",
            "35.668796,139.786583",
            "35.66849,139.746192",
            "35.69995,139.735037",
            "35.72349	,139.749553",
            "35.718801,139.781518",
            "35.694484,139.804232",
            "35.629417,139.796671",
            "35.598187,139.758968",
            "35.651328,139.691599",
            "35.549786,139.786522",
            "35.669726,139.620901", #世田谷
            "35.668183,139.709361",
            "35.724688,139.65612",
            "35.671529,139.646176",
            "35.735037,139.749607",
            "35.754421,139.745645",
            "35.752063,139.76361",
            "35.752364,139.676337",
            "35.757756,139.620976",
            "35.740193,139.797811",
            "35.755326,139.871866", #葛飾
            "35.693059,35.693059"
            ]

locations.each do |location|
  #uri = URI.parse URI.encode "https://maps.googleapis.com/maps/api/place/textsearch/json?query=音楽スタジオ+新宿駅&language=ja&key=#{ENV['GOOGLEMAPS_IP_KEY']}"
  uri = URI.parse URI.encode "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=音楽スタジオ&location=#{location}&radius=10000&language=ja&key=#{ENV['GOOGLEMAPS_IP_KEY']}"
  res = HTTP.get(uri).to_s
  response = JSON.parse(res)
  
  #レスポンス最大20件分の保存処理
  response['results'].each do |result|
    lat = result['geometry']['location']['lat']
    lng = result['geometry']['location']['lng']
    #逆ジオコーディング
    geo_uri = URI.parse URI.encode "https://maps.googleapis.com/maps/api/geocode/json?latlng=#{lat},#{lng}&sensor=false&language=ja&key=#{ENV['GOOGLEMAPS_IP_KEY']}"
    geo_res = HTTP.get(geo_uri).to_s
    geo_response = JSON.parse(geo_res)
    address = geo_response['results'][0]['formatted_address'].slice(13..-1)
    #都道府県を取得したくなったらこれを使う
    #prefecture = geo_response['results'][0]['address_components'][4]['long_name']
    
    studio = Studio.new(
                  name: result['name'],
                  area_id: 1,
                  latitude: lat,
                  longitude: lng,
                  address: address,
                  place_id: result["place_id"]

    )
    #写真がある場合
    if result.has_key?("photos")
      photo_reference = result['photos'][0]['photo_reference'] 
      url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=400&photoreference=#{photo_reference}&key=#{ENV['GOOGLEMAPS_IP_KEY']}"
      studio.remote_image_url = url
    else
      studio.image = "default-studio-icon.jpeg"
    end
    studio.save
  end

  #レスポンスにnext_page_tokenがある場合（21件以上ある場合）
  if response.has_key?("next_page_token") == true
    token = response["next_page_token"]
    2.times do
      #time.sleep(2)
      uri = URI.parse URI.encode "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=音楽スタジオ&location=#{location}&radius=10000&language=ja&pagetoken=#{token}&key=#{ENV['GOOGLEMAPS_IP_KEY']}"
      res = HTTP.get(uri).to_s
      response = JSON.parse(res)
      response['results'].each do |result|
        lat = result['geometry']['location']['lat']
        lng = result['geometry']['location']['lng']
        #逆ジオコーディング
        geo_uri = URI.parse URI.encode "https://maps.googleapis.com/maps/api/geocode/json?latlng=#{lat},#{lng}&sensor=false&language=ja&key=#{ENV['GOOGLEMAPS_IP_KEY']}"
        geo_res = HTTP.get(geo_uri).to_s
        geo_response = JSON.parse(geo_res)
        address = geo_response['results'][0]['formatted_address'].slice(13..-1)
        #都道府県を取得したくなったらこれを使う
        #prefecture = geo_response['results'][0]['address_components'][4]['long_name']
        studio = Studio.new(
                      name: result['name'],
                      area_id: 1,
                      latitude: lat,
                      longitude: lng,
                      address: address,
                      place_id: result["place_id"]
        )
        
        #写真がある場合
        if result.has_key?("photos")
          photo_reference = result['photos'][0]['photo_reference'] 
          url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=400&photoreference=#{photo_reference}&key=#{ENV['GOOGLEMAPS_IP_KEY']}"
          studio.remote_image_url = url
        else
          studio.image = "default-studio-icon.jpeg"
        end
        studio.save
      end
      if response.has_key?("next_page_token") == true
        token =response["next_page_token"] 
      else
        break
      end
    end
  end
end