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

    trait :gist do
      url { 'https://gist.github.com/galuropek/c324f0d28418078cae9aa4363e2dcf16' }
    end
  end
end
