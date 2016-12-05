FactoryGirl.define do
  factory :list do
    sequence(:name) { |n| "#{Faker::Name.title} #{n}" }
    user nil
  end
end
