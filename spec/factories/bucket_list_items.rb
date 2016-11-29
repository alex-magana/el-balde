FactoryGirl.define do
  factory :bucket_list_item do
    name Faker::Name.title
    done false
    bucket_list nil
  end
end
