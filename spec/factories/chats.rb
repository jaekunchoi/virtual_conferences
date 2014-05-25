# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chat do
    from_user 1
    to_user 1
    message "MyText"
  end
end
