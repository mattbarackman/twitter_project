root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
require File.join(root, 'config', 'environment')

log = File.join(root, 'log', 'stream.log')

topic_names = ARGV[1].split(",")

topics = Topic.where(name: topic_names)

if topics.any? && topics.length == topic_names.length
  daemon = TweetStream::Daemon.new("streaming_daemon_" + topics.map(&:id).join("_"))
  daemon.track(topic_names) do |status|
    if status.kind_of? Twitter::Tweet
      user_mentions = status.user_mentions.map(&:screen_name)
      hashtags = status.hashtags.map(&:text)
      urls = status.uris.select(&:expanded_url?).map(&:expanded_url).map(&:to_s)

      matching_topics = user_mentions & topic_names

      matching_topics.each do |topic_name|

        topic = Topic.find_by_name(topic_name)

        tweet = Tweet.create(
          text: status.text,
          topic_id: topic.id,
          hashtags: hashtags,
          users: user_mentions,
          urls: urls
        )
        TweetJob.perform_later(tweet.id)
      end
    end
  end
end

  # topic_names = ["@HillaryClinton", "@realDonaldTrump", "@BernieSanders"]

  # client = TweetStream::Client.new
  # client.track(topic_names) do |status|
  #   if status.kind_of? Twitter::Tweet
  #     user_mentions = status.user_mentions.map(&:screen_name)
  #     hashtags = status.hashtags.map(&:text)
  #     urls = status.uris.select(&:expanded_url?).map(&:expanded_url).map(&:to_s)

  #     matching_topics = user_mentions.map{|um| "@" + um} & topic_names

  #     p status.created_at.class

  #     matching_topics.each do |topic_name|

  #       topic = Topic.find_by_name(topic_name)

  #       tweet = Tweet.create(
  #         text: status.text,
  #         topic_id: topic.id,
  #         hashtags: hashtags,
  #         users: user_mentions,
  #         urls: urls
  #       )
  #       TweetJob.perform_later(tweet.id)
  #     end
  #   end
  # end