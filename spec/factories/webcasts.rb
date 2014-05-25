# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :webcast do
    name "MyString"
    hall nil
    webcast_type "MyString"
    media_type "MyString"
    user nil
    details "MyString"
    template nil
    background_colour "MyString"
  end
end
