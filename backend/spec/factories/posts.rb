FactoryBot.define do
  factory :post do
    content { "MyText" }
    list_1 { "MyString" }
    list_2 { "MyString" }
    list_3 { "MyString" }
    list_4 { "MyString" }
    user { nil }
  end
end
