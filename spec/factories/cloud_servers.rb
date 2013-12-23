# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cloud_server do
    name "Cloud Server"
    description "Cloud Server Description"
    username "username"
    password "changeme"
    url "http://opendvi.com/auth/v2.0/"
  end
end
