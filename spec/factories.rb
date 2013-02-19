FactoryGirl.define do
  factory :user do
    name     "C.B. User"
    email    "cbuser@example.com"
    password "foobar"
    password_confirmation "foobar"
  end  
end