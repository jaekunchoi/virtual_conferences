# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :moderated_chat do
    message "MyText"
    webcast nil
    from_user_id 1
    to_user_id 1
    approved false
  end
end
