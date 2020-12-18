# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

red_avatar = File.open(Rails.root.join("public/red_avatar.jpeg"))
blue_avatar = File.open(Rails.root.join("public/blue_avatar.jpeg"))
User.create!(
  name: "hogehoge",
  email: "hoge@hoge.com",
  password: "hogehoge",
  password_confirmation: "hogehoge",
  avatar: red_avatar,
  admin: true
)

(2..70).each do |n|
  name  = Faker::Internet.username(specifier: 6..20, separators: %w[_ -])
  email = "example-#{n}@example.com"
  password = "password"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    avatar: blue_avatar
  )
end
