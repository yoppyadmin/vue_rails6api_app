url = "http://robohash.org/1.png"
fileName = File.basename(url) # -> "1.png"
dirName = "#{Rails.root}/public/seed_#{Rails.env}/" # -> "/app/backend/public/test/"
filePath = dirName + fileName # -> "/app/backend/public/test/1.png"
FileUtils.mkdir_p(dirName) unless FileTest.exist?(dirName)
open(filePath, 'wb') do |output|
  open(url) do |data|
    output.write(data.read)
  end
end
User.create!(
  name: "hogehoge",
  email: "hoge@hoge.com",
  password: "hogehoge",
  password_confirmation: "hogehoge",
  avatar: File.open(Rails.root.join(filePath)),
  admin: true
)

(2..50).each do |n|
  name  = Faker::Internet.username(specifier: 6..20, separators: %w[_ -])
  email = "example-#{n}@example.com"
  password = "password"
  url = "http://robohash.org/#{n}.png"
  fileName = File.basename(url)
  dirName = "#{Rails.root}/public/seed_#{Rails.env}/"
  filePath = dirName + fileName
  FileUtils.mkdir_p(dirName) unless FileTest.exist?(dirName)
  open(filePath, 'wb') do |output|
    open(url) do |data|
      output.write(data.read)
    end
  end
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    avatar: File.open(Rails.root.join(filePath))
  )
end

# red_avatar = File.open(Rails.root.join("public/red_avatar.jpeg"))
# blue_avatar = File.open(Rails.root.join("public/blue_avatar.jpeg"))
