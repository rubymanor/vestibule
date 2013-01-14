desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  puts "Updating Twitter images..."
  # User.update_twitter_images
  puts "Done."
end
