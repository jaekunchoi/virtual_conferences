# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    name "MyString"
    status "MyString"
    start "2013-11-11 22:52:32"
    finish "2013-11-11 22:52:32"
    event_url "MyString"
    event_reports_url "MyString"
    logo1 "MyString"
    logo2 "MyString"
    top_bar_background "MyString"
    colour "MyString"
    publish_event false
    event_image "MyString"
    description "MyText"
    search_keywords "MyString"
    closed_event_redirect "MyString"
    comments "MyText"
    venue nil
  end
end
