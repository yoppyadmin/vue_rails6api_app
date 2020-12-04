class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process resize_to_fill: [200, 200, "Center"]

  storage :file
  # if Rails.env.development? || Rails.env.test?
  #   storage :file
  # else
  #   storage :fog
  # end

  def store_dir
    "uploads_#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}" if Rails.env.production?
    if Rails.env.test?
      "uploads_#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    elsif Rails.env.development?
      "uploads_#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end
end
