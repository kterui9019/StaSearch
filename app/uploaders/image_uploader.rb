class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def default_url
    "default-#{model.class.to_s.underscore}-icon.jpeg"
  end

   # リサイズしたり画像形式を変更するのに必要
  include CarrierWave::RMagick

=begin
  version :thumb, if: :has_thumbnail? do
    process :dynamic_resize_to_fit
  end

  def dynamic_resize_to_fit
    size = model.class::THUMBNAIL_SIZE
    resize_to_fit size[0], size[1]
  end

  def has_thumbnail? new_file
    model.class::const_defined? :THUMBNAIL_SIZE
  end
=end
 
 # 画像の上限を480x480にする
  process :resize_to_limit => [480, 480]
 
  # 保存形式をJPGにする
  process :convert => 'jpg'

=begin 
  # サムネイルを生成する設定
  version :thumb do
    process :resize_to_limit => [300, 300]
  end
  
  version :thumb150 do
    process :resize_to_limit => [150, 150]
  end
  
  version :thumb100 do
    process :resize_to_limit => [100, 100]
  end
 
  version :thumb30 do
    process :resize_to_limit => [30, 30]
  end
=end

  # jpg,jpeg,gif,pngしか受け付けない
  def extension_white_list
    %w(jpg jpeg gif png)
  end
 
 # 拡張子が同じでないとGIFをJPGとかにコンバートできないので、ファイル名を変更
  def filename
    super.chomp(File.extname(super)) + '.jpg' if original_filename.present?
  end
 
 #ファイル名を日付にするとタイミングのせいでサムネイル名がずれる
 #ファイル名はランダムで一意になる
  #def filename
  #  "#{secure_token}.#{file.extension}" if original_filename.present?
  #end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

 
  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end

