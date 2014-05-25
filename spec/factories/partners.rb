# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :partner do
    name "MyString"
    description "MyText"
    partner_url "MyString"
    logo_id "MyString"
    user nil
    created_at "2013-11-19 10:56:35"
    updated_at "2013-11-19 10:56:35"
  end
end
