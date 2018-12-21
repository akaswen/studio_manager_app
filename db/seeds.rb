User.destroy_all

# teacher seed data
teacher = User.new(first_name: "Aaron", last_name: "Kaswen", email: "aaron@example.com", password: "Password1", password_confirmation: "Password1", teacher: true, status: nil)

teacher.build_address(street_address: "425 Encinal St", city: "Santa Cruz", state: "CA", zip_code: "95060")

teacher.build_phone_number(number: "555 555 5555", kind: "Mobile")

teacher.build_schedule

teacher.save!

teacher.confirm

# sample student
student = User.new(first_name: "Student", last_name: "McStudington", email: "student@example.com", password: "Password1", password_confirmation: "Password1", student: true, status: nil, rate_per_hour: 45)

student.build_address(street_address: "130 Emmett St", city: "Santa Cruz", state: "CA", zip_code: "95060")

student.build_phone_number(number: "555 555 5555", kind: "Mobile")

student.save!

student.confirm

# new student requests
5.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
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
  user.build_address(street_address: street_address, city: city, state: state, zip_code: zip_code)
  user.build_phone_number(number: number, kind: kind)

  unless user.valid?
    puts user.inspect
    puts user.address.inspect
    puts user.phone_number.inspect
  end

  user.save!

  user.confirm
end

# wait list
10.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
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
  user.build_address(street_address: street_address, city: city, state: state, zip_code: zip_code)
  user.build_phone_number(number: number, kind: kind)
  user.status = "Wait Listed"

  unless user.valid? 
    puts user.inspect
    puts user.address.inspect
    puts user.phone_number.inspect
  end
  user.save!

  user.confirm
end

# wait list of different sign up times
5.times do |n|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
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
  user.build_address(street_address: street_address, city: city, state: state, zip_code: zip_code)
  user.build_phone_number(number: number, kind: kind)
  user.status = "Wait Listed"

  unless user.valid? 
    puts user.inspect
    puts user.address.inspect
    puts user.phone_number.inspect
  end
  user.save!

  user.update_attribute(:created_at, Time.now - n.days)
  user.confirm

end

# students
10.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
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
  user.build_address(street_address: street_address, city: city, state: state, zip_code: zip_code)
  user.build_phone_number(number: number, kind: kind)
  user.student = true
  user.status = nil
  unless user.valid? 
    puts user.inspect
    puts user.address.inspect
    puts user.phone_number.inspect
  end

  user.save!

  user.confirm
end

# some confirmed lessons

students = User.where(student: true).all

# one set of weekly lessons starting 4 weeks from today
4.times do |n|
  start_time = Time.now.beginning_of_day + 10.hours + 2.weeks + n.weeks
  end_time = start_time + 1.hour
  lesson = Lesson.create!(start_time: start_time, end_time: end_time, location: "teacher", confirmed: true, kind: "voice", student_id: student.id, teacher_id: teacher.id)
  lesson.update_attribute(:repeat, true) if n == 3
end

# one weekly lesson request

4.times do |n|
  start_time = Time.now.beginning_of_day + 9.hours + 1.day + n.weeks
  lesson = Lesson.new(start_time: start_time, end_time: start_time + 1.hour, location: "teacher", kind: "piano")
  lesson.student = student
  lesson.teacher = teacher
  lesson.save!
  lesson.update_attribute(:repeat, true) if n == 3
end

# single lesson request

  start_time = Time.now.beginning_of_day + 9.hours + 2.days
  lesson = Lesson.new(start_time: start_time, end_time: start_time + 1.hour, location: "teacher", kind: "voice")
  lesson.student = student
  lesson.teacher = teacher
  lesson.save!

#unpaid lessons past deadline

2.times do |n|
  start_time = Time.now.beginning_of_day + 9.hours + 3.days
  lesson = Lesson.new(start_time: start_time, end_time: start_time + 1.hour, location: "teacher", confirmed: true, kind: "voice/piano")
  lesson.student = student
  lesson.teacher = teacher
  lesson.save!
  lesson.update_attribute(:start_time, start_time - (4 - n).days)
  lesson.update_attribute(:end_time, lesson.end_time - (4 - n).days)
end

# payment history

3.times do |y| #payments over the last three years
  12.times do |m| #payments each month
    student = students[rand(students.length - 1)]
    amount = rand(40..100)
    p = student.payments.create!(amount: amount)
    p.update_attribute(:created_at, p.created_at - m.months - y.years)
  end
end
