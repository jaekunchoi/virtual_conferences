# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :booth do
    name "MyString"
    company_website "MyString"
    social_media "MyText"
    contact_info "MyText"
    email "MyString"
    about_us "MyText"
    greeting_type nil
    created_at "2013-11-15 18:08:11"
    updated_at "2013-11-15 18:08:11"
  end
end
