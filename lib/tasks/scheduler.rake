desc "This task is called by the Heroku scheduler add-on"

task :delete_old_occurrences => :environment do
  Occurrence.delete_old
end
