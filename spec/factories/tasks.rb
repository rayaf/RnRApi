FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    deadline { Faker::Date.forward }
    done { false }
    association :user, factory: :user
  end
end