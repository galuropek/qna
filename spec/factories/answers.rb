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

    trait :with_link do
      links { [create(:link)] }
    end
  end
end
