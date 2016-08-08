namespace :topics do

  task :stream => :environment do |t, args|
    client = TweetStream::Client.new

    topic_names = Topic.all.pluck(:value)

    client.track(topic_names.join(","), lang: "en") do |status|

      if status.kind_of? Twitter::Tweet

        user_mentions = status.user_mentions.map(&:screen_name)
        full_text = status.full_text
        hashtags = status.hashtags.map(&:text)
        urls = status.uris.select(&:expanded_url?).map(&:expanded_url).map(&:to_s)

        p full_text

        topic_names.each do |topic_name|

          if full_text.include?(topic_name)

            tweet_info = {
              topic_name: topic_name,
              twitter_id: status.id,
              tweeted_at: status.created_at.to_s,
              full_text: full_text,
              user_mentions: user_mentions,
              hashtags: hashtags,
              urls: urls
            }

            TweetJob.perform_later(tweet_info)

          end

        end

      end
    end
  end

end