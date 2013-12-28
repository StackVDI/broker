FactoryGirl.define do
  
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    email 
    first_name 'John'
    last_name 'Doe'
    password 'changeme99'
    approved false
  end

end
