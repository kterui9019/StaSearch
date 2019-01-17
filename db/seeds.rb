studios = Studio.all

studios.each do |studio|
  x = studio.longitude.to_f
  y = studio.latitude.to_f
  access_uri = URI.parse URI.encode "http://map.simpleapi.net/stationapi?x=#{x}&y=#{y}&output=json"
  access_res = HTTP.get(access_uri).to_s
  access_responses = JSON.parse(access_res)
  access_responses.each do |access_response|
    Access.create(name: access_response["name"],
                        line: access_response["line"],
                        distanceKm: access_response["distanceKm"],
                        traveltime: access_response["traveltime"],
                        studio_id: studio.id)
  end
end

=begin
if Rails.env.production?
    # 本番用設定を書く
else
  # 開発・テスト用設定を書く
  tags =['#料金が安い', '#設備がキレイ', '#機材レンタル有り','#待合室が広い','#wi-fi有', '#24時間営業', '#リハーサル', '#レコーディング']
  tags.each do |tag|
    HashTag.create!(tag: tag)
  end
  User.create!(
              name:"foobar",
              email:"foobar@gmail.com",
              password:"foobar")
              
  fees = ["0~999円",
        "1000~1999円",
        "2000~2999円",
        "3000~3999円",
        "4000~4999円",
        "5000~5999円",
        "6000~6999円",
        "7000~7999円",
        "8000~8999円",
        "9000~9999円"]

  fees.each do |fee|
    Fee.create!(fee: fee)
  end
end

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
            "35.693059,35.693059",
            "35.617579,139.335315",
            "35.727354,139.36986",
            "35.700419,139.589688",
            "35.673275,139.580228",
            "35.830314,139.263568",
            "35.670488,139.45922",
            "35.696368,139.367957",
            "35.636327,139.556512",
            "35.542217,139.467602",
            "35.689652,139.500723",
            "35.728845,139.49856",
            "35.655453,139.406756",
            "35.749897,139.482747",
            "35.702823,139.479679",
            "35.674105,139.445242",
            "35.748842,139.329707",
            "35.626625,139.574252",
            "35.751978,139.435417",
            "35.776137,139.499524",
            "35.753699,139.496259",
            "35.743657,139.359624",
            "35.648156,139.442913",
            "35.644584,139.477742",
            "35.75369,139.338544",
            "35.718576,139.250718",
            "35.75307,139.55756",
            "35.761085,139.358706",
            "35.764089,139.216731",
            "35.749685,139.022509",
            "34.716898,139.377229",
            "34.326527,139.213502",
            "34.064749,139.496507",
            "33.093013,139.84051",
            "24.779258,141.319783"]

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

    studio = Studio.new(
                  name: result['name'],
                  latitude: lat,
                  longitude: lng,
                  address: address,
                  place_id: result["place_id"],
                  created_user_id: 1
    )
    
    #すでにあるplace_idの場合はスキップ
    next if studio.invalid?
    
    #写真がある場合
    if result.has_key?("photos")
      photo_reference = result['photos'][0]['photo_reference'] 
      url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=400&photoreference=#{photo_reference}&key=#{ENV['GOOGLEMAPS_IP_KEY']}"
      studio.remote_image_url = url
    end
    studio.save
    
    #アクセス情報の登録
    x = studio.longitude.to_f
    y = studio.latitude.to_f
    access_uri = URI.parse URI.encode "http://map.simpleapi.net/stationapi?x=#{x}&y=#{y}&output=json"
    access_res = HTTP.get(access_uri).to_s
    access_responses = JSON.parse(access_res)
    
    access_responses.each do |access_response|
      access = Access.new(name: access_response["name"],
                          line: access_response["line"],
                          distanceKm: access_response["distanceKm"],
                          traveltime: access_response["traveltime"],
                          studio_id: studio.id)
      access.save
    end
  end

  #レスポンスにnext_page_tokenがある場合（21件以上ある場合）
  if response.has_key?("next_page_token") == true
    token = response["next_page_token"]
    2.times do
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
        studio = Studio.new(
                      name: result['name'],
                      latitude: lat,
                      longitude: lng,
                      address: address,
                      place_id: result["place_id"],
                      created_user_id: 1
        )
        
        #すでにあるplace_idの場合はスキップ
        next if !studio.valid?
        
        #写真がある場合
        if result.has_key?("photos")
          photo_reference = result['photos'][0]['photo_reference'] 
          url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=400&photoreference=#{photo_reference}&key=#{ENV['GOOGLEMAPS_IP_KEY']}"
          studio.remote_image_url = url
        end
        studio.save
        #アクセス情報の登録
        x = studio.longitude.to_f
        y = studio.latitude.to_f
        access_uri = URI.parse URI.encode "http://map.simpleapi.net/stationapi?x=#{x}&y=#{y}&output=json"
        access_res = HTTP.get(access_uri).to_s
        access_response = JSON.parse(access_res)
        access = Access.new(
          name: access_response[0]["name"],
          line: access_response[0]["line"],
          distanceKm: access_response[0]["distanceKm"],
          traveltime: access_response[0]["traveltime"],
          studio_id: studio.id
          )
        access.save
      end
      if response.has_key?("next_page_token") == true
        token =response["next_page_token"] 
      else
        break
      end
    end
  end
end
=end