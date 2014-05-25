# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :presentation do
    name "MyString"
    description "MyText"
    presentation_url "MyString"
    relevant_logo_id 1
    user nil
  end
end
