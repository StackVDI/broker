FactoryGirl.define do
  
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    email 
    name 'John Doe'
    password 'changeme99'
    approved false
  end

end
