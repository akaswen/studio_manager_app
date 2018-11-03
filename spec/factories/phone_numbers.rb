FactoryBot.define do
  factory :phone_number do
    number { "555 555 5555" }
    kind { "home" }
 end

  factory :cell_number, class: PhoneNumber do
    number { "555 555 5555" }
    kind { "Mobile" }
  end
end
