FactoryBot.define do
  sequence(:body) { |n| "Answer body #{n}" }

  factory :answer do
    title { "MyString" }
    body
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
