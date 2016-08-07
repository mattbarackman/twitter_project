namespace :twitter_stream_consumers do

  desc ""

  task :start, [:topic] => :environment do |t, args|

    specific_topic = args[:topic]

    if specific_topic
      topics = Topic.where(:name => specific_topic)
    else
      topics = Topic.all.to_a
    end

    topics.each { | topic | topic.streaming("start") }

  end

  task :stop, [:topic] => :environment do |t, args|

    specific_topic = args[:topic]

    if specific_topic
      topics = Topic.where(:name => specific_topic)
    else
      topics = Topic.all.to_a
    end

    topics.each { | topic | topic.streaming("stop") }

  end

end
