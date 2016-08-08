FactoryGirl.define do
  factory :topic do
    value { Faker::Hipster.word }
  end
end