# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :uploaded_file do
    file_id 1
    name "MyString"
    file_group "MyString"
    saved_file_name "MyString"
    mime_type "MyString"
  end
end
