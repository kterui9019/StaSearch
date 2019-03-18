module ApplicationHelper
  def access_info(accesses)
    if accesses&.count > 1
      return accesses.first.name + " ほか" + (accesses.count - 1).to_s + "駅"
    else
      return accesses.first.name
    end
  end
end

def default_meta_tags
  {
    description: "スタサーチは、音楽スタジオの検索、口コミの閲覧、お気に入り保存ができるWebサービスです。",
    icon: image_url("favicon.ico"), # favicon
    noindex: ! Rails.env.production?, # production環境以外はnoindex  
    charset: "UTF-8",
    viewport: "width=device-width, initial-scale=1",
    
    # OGPの設定
    og: {
      title: "スタサーチ | 口コミとランキングで選べる音楽スタジオ探し",
      type: "website",
      url: request.original_url,
      site_name: "スタサーチ",
      description: "スタサーチは、音楽スタジオの検索、口コミの閲覧、お気に入り保存ができるWebサービスです。",
      locale: "ja_JP"
    } 
  }
end