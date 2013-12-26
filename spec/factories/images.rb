# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :image do
    name "MyString"
    description "MyString"
    association :cloud_server, factory: :cloud_server, strategy: :build
    machine "MyString"
    flavor "MyString"
    number_of_instances 1
  end
end
