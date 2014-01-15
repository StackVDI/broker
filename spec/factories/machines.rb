# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :machine do
    association :image, :factory =>:image, :strategy => :create
    association :user, :factory => :user, :strategy => :create
    remote_username "username"
    remote_password "password"
    remote_address "www.openvdi.com"
    remote_port "2222"
  end
end
