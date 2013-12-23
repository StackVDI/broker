# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :image do
    name "MyString"
    description "MyString"
    cloud_server nil
    machine "MyString"
    flavor "MyString"
    number_of_instances 1
  end
end
