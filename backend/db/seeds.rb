url = Faker::Avatar.image(slug: 1, format: "jpg").split(/\?/).first
file_name = File.basename(url) # -> "1.png"
dir_name = Rails.root.join("public/seed_#{Rails.env}/").to_s # -> "/app/backend/public/test/"
file_path = dir_name + file_name # -> "/app/backend/public/test/1.png"
FileUtils.mkdir_p(dir_name) unless FileTest.exist?(dir_name)
File.open(file_path, "wb") do |output|
  URI.parse(url).open do |data|
    output.write(data.read)
  end
end
User.create!(
  name: "hogehoge",
  email: "hoge@hoge.com",
  password: "hogehoge",
  password_confirmation: "hogehoge",
  avatar: File.open(Rails.root.join(file_path)),
  admin: true
)

(2..50).each do |n|
  name  = Faker::Internet.username(specifier: 6..20, separators: %w[_ -])
  email = "example-#{n}@example.com"
  password = "password"
  url = Faker::Avatar.image(slug: n, format: "jpg").split(/\?/).first
  file_name = File.basename(url)
  dir_name = Rails.root.join("public/seed_#{Rails.env}/").to_s
  file_path = dir_name + file_name
  FileUtils.mkdir_p(dir_name) unless FileTest.exist?(dir_name)
  File.open(file_path, "wb") do |output|
    URI.parse(url).open do |data|
      output.write(data.read)
    end
  end
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    avatar: File.open(Rails.root.join(file_path))
  )
end

# red_avatar = File.open(Rails.root.join("public/red_avatar.jpeg"))
# blue_avatar = File.open(Rails.root.join("public/blue_avatar.jpeg"))
