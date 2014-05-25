# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :literature do
    name "MyString"
    file_category "MyString"
    asset_type nil
    expiration_date "2013-11-18 18:08:26"
    share false
    description "MyText"
    file_url "MyString"
    user nil
    created_at "2013-11-18 18:08:26"
    updated_at "2013-11-18 18:08:26"
  end
end
