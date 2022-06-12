FactoryBot.define do
  factory :badge do
    name { "MyString" }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/storage/images/test.jpg", 'image/jpg') }
  end
end
