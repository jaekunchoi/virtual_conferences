# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :hall do
    name "MyString"
    template_id 1
    background_id 1
    colour "MyString"
    greeting "MyString"
    greeting_type "MyString"
    greeting_enable false
    jumbotron "MyString"
    jumbotron_enable false
  end
end
