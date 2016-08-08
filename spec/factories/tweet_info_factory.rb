TweetInfo = Struct.new(
    :topic_name,
    :twitter_id,
    :tweeted_at,
    :usernames,
    :hashtags,
    :urls
  )

FactoryGirl.define do
  factory :tweet_info do
    sequence :twitter_id
    tweeted_at {DateTime.current.to_s}
    usernames []
    hashtags []
    urls []
    skip_create

    trait :with_urls do
      urls {Array.new(3){Faker::Internet.url}}
    end

    trait :with_usernames do
      usernames {Array.new(3){Faker::Internet.user_name}}
    end

    trait :with_hashtags do
      hashtags {Array.new(3){Faker::Hipster.word}}
    end

    trait :old do
      tweeted_at {(DateTime.current - 90.minutes).to_s}
    end

  end
end