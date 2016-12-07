FactoryGirl.define do
  factory :authentication do
    token Faker::Crypto.sha256
    user nil
  end
end
