FactoryGirl.define do
  factory :bucket_list do
    sequence(:name) { |n| "#{Faker::Name.title} #{n}" }
    user nil
  end
end
