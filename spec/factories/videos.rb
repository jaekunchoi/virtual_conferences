# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video do
    name "MyString"
    file_category "MyString"
    asset_type nil
    expiration_date "MyString"
    share false
    description "MyText"
    video_source "MyString"
    video_duration 1
    thumbnail "MyString"
  end
end
