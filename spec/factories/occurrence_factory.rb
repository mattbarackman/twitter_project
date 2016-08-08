FactoryGirl.define do
  factory :occurrence do
    value { Faker::Hipster.word }
    type "Hashtag"
    tweeted_at { DateTime.current.to_s }
    topic

    trait :old do
      tweeted_at {(DateTime.current - 90.minutes).to_s}
    end

    factory :url_occurrence, :class => UrlOccurrence do
      type "UrlOccurrence"
    end

    factory :username_occurrence, :class => UsernameOccurrence do
      type "UrlOccurrence"
    end

    factory :hashtag_occurrence, :class => HashtagOccurrence do
      type "HashtagOccurrence"
    end

  end
end