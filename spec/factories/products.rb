# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    name "MyString"
    description "MyText"
    product_url "MyString"
    image_id 1
    request_info false
    email_notification false
    emails "MyString"
    user nil
    created_at "2013-11-18 17:57:28"
    updated_at "2013-11-18 17:57:28"
  end
end
