# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :forum do
    name "MyString"
    description "MyText"
    user nil
  end
end
