FactoryGirl.define do
  factory :bucket_list do
    name { Faker::Name.title }
    user nil
  end
end
