FactoryGirl.define do
  
  sequence :name do |n|
    "role_numero_#{n}"
  end

  factory :role do
    name 
  end

end
