FactoryGirl.define do
  factory :item do
    name Faker::Name.title
    done false
    list nil
  end
end
