namespace :topics do

  task :start_streaming => :environment do |t, args|
    Topic.streaming("start")
  end

  task :stop_streaming => :environment do |t, args|
    Topic.streaming("stop")
  end

  task :restart_streaming => :environment do |t, args|
    Topic.streaming("restart")
  end

end