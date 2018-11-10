# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all

u = User.new(first_name: "Aaron", last_name: "Kaswen", email: "aaron@example.com", password: "Password1", password_confirmation: "Password1", teacher: true, status: nil)

u.addresses.build(street_address: Faker::Address.street_address, city: Faker::Address.city, state: Faker::Address.state_abbr, zip_code: Faker::Address.zip[0..4])

u.phone_numbers.build(number: "555 555 5555", kind: "Mobile")

u.save!

u.confirm

# new student requests
5.times do
  first_name = Faker::ElderScrolls.first_name
  last_name = Faker::ElderScrolls.last_name
  email = Faker::Internet.unique.email
  password = "Password1"
  password_confirmation = "Password1"

  number = "555 555 5555"
  kind = "Mobile"

  street_address = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state_abbr
  zip_code = Faker::Address.zip[0..4]

  user = User.new(first_name: first_name, last_name: last_name, email: email, password: password, password_confirmation: password_confirmation)
  user.addresses.build(street_address: street_address, city: city, state: state, zip_code: zip_code)
  user.phone_numbers.build(number: number, kind: kind)

  unless user.valid?
    puts user.inspect
    puts user.addresses.first.inspect
    puts user.phone_numbers.first.inspect
  end

  user.save!

  user.confirm
end

# wait list
50.times do
  first_name = Faker::ElderScrolls.first_name
  last_name = Faker::ElderScrolls.last_name
  email = Faker::Internet.unique.email
  password = "Password1"
  password_confirmation = "Password1"

  number = "555 555 5555"
  kind = "Mobile"

  street_address = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state_abbr
  zip_code = Faker::Address.zip[0..4]

  user = User.new(first_name: first_name, last_name: last_name, email: email, password: password, password_confirmation: password_confirmation)
  user.addresses.build(street_address: street_address, city: city, state: state, zip_code: zip_code)
  user.phone_numbers.build(number: number, kind: kind)
  user.status = "Wait Listed"

  unless user.valid? 
    puts user.inspect
    puts user.addresses.first.inspect
    puts user.phone_numbers.first.inspect
  end
  user.save!

  user.confirm
end

# wait list of different sign up times
5.times do |n|
  first_name = Faker::ElderScrolls.first_name
  last_name = Faker::ElderScrolls.last_name
  email = Faker::Internet.unique.email
  password = "Password1"
  password_confirmation = "Password1"

  number = "555 555 5555"
  kind = "Mobile"

  street_address = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state_abbr
  zip_code = Faker::Address.zip[0..4]

  user = User.new(first_name: first_name, last_name: last_name, email: email, password: password, password_confirmation: password_confirmation)
  user.addresses.build(street_address: street_address, city: city, state: state, zip_code: zip_code)
  user.phone_numbers.build(number: number, kind: kind)
  user.status = "Wait Listed"

  unless user.valid? 
    puts user.inspect
    puts user.addresses.first.inspect
    puts user.phone_numbers.first.inspect
  end
  user.save!

  user.update_attribute(:created_at, Time.now - n.days)
  user.confirm

end

# students
50.times do
  first_name = Faker::ElderScrolls.first_name
  last_name = Faker::ElderScrolls.last_name
  email = Faker::Internet.unique.email
  password = "Password1"
  password_confirmation = "Password1"
  rate_per_hour = 45

  number = "555 555 5555"
  kind = "Mobile"

  street_address = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state_abbr
  zip_code = Faker::Address.zip[0..4]

  user = User.new(first_name: first_name, last_name: last_name, email: email, password: password, password_confirmation: password_confirmation, rate_per_hour: rate_per_hour)
  user.addresses.build(street_address: street_address, city: city, state: state, zip_code: zip_code)
  user.phone_numbers.build(number: number, kind: kind)
  user.student = true
  user.status = nil
  unless user.valid? 
    puts user.inspect
    puts user.addresses.first.inspect
    puts user.phone_numbers.first.inspect
  end

  user.save!

  user.confirm

end
