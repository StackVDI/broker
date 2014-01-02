# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  sequence :remote_username do |n|
    "remote_username_#{n}"
  end

  sequence :remote_password do |n|
    "remote_password_#{n}"
  end

  sequence :remote_address do |n|
    "remote_address_#{n}"
  end

  sequence :remote_port do |n|
    "remote_port_#{n}"
  end

  factory :machine do
    association :user, factory: :user, strategy: :build
    association :image, factory: :image, strategy: :build
    remote_username 
    remote_password 
    remote_address 
    remote_port 
  end
end

