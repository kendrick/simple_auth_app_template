namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Kendrick Arnett",
                 email: "kmarnett@gmail.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Name.name
      email = Faker::Internet.user_name(name) + '@' + Faker::Internet.domain_name
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end