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
user = User.create!(
  name: "hogehoge",
  email: "hoge@hoge.com",
  password: "hogehoge",
  password_confirmation: "hogehoge",
  avatar: File.open(Rails.root.join(file_path)),
  admin: true
)
user.create_account!(account_number: user.id)

list_1 = Faker::Lorem.sentence(word_count: 3)
list_2 = Faker::Lorem.sentence(word_count: 3)
list_3 = [Faker::Lorem.sentence(word_count: 3), nil].sample
list_4 = [Faker::Lorem.sentence(word_count: 3), nil].sample
25.times do
  list_1 = Faker::Lorem.sentence(word_count: 3)
  list_2 = Faker::Lorem.sentence(word_count: 3)
  list_3 = [Faker::Lorem.sentence(word_count: 3), nil].sample
  list_4 = [Faker::Lorem.sentence(word_count: 3), nil].sample
  post = user.posts.create!(
    content: Faker::Lorem.question(word_count: 4),
    list_1: list_1,
    list_2: list_2,
    list_3: list_3,
    list_4: list_3.nil? ? nil : list_4
  )
  post.create_quantity!
end

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
  other_user = User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    avatar: File.open(Rails.root.join(file_path))
  )
  other_user.create_account!(account_number: other_user.id)
end

other_users = User.where("id >= ?", 2)
other_users.each do |other_user|
  list_1 = Faker::Lorem.sentence(word_count: 3)
  list_2 = Faker::Lorem.sentence(word_count: 3)
  list_3 = [Faker::Lorem.sentence(word_count: 3), nil].sample
  list_4 = [Faker::Lorem.sentence(word_count: 3), nil].sample
  post = other_user.posts.create!(
    content: Faker::Lorem.question(word_count: 4),
    list_1: list_1,
    list_2: list_2,
    list_3: list_3,
    list_4: list_3.nil? ? nil : list_4
  )
  post.create_quantity!
end

# red_avatar = File.open(Rails.root.join("public/red_avatar.jpeg"))
# blue_avatar = File.open(Rails.root.join("public/blue_avatar.jpeg"))
