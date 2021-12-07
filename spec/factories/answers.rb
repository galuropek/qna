FactoryBot.define do
  factory :answer do
    title { "MyString" }
    body { "MyText" }
    question
    user

    trait :invalid do
      title { nil }
    end
  end
end
