FactoryBot.define do
  factory :link do
    name { "Google" }
    url { "https://www.google.com/" }
    linkable { create(:question) }

    trait :question do
      linkable { create(:question) }
    end

    trait :answer do
      linkable { create(:answer) }
    end
  end
end
