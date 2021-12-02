FactoryBot.define do
  sequence :email do |n|
    "user#{n}@mail.com"
  end

  factory :user do
    email
    password { 'test1234' }
    password_confirmation { 'test1234' }
  end
end
