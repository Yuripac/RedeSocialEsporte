desc "this task is called by heroku scheduler add-on"

task check_activities_periodically: :environment do
  Activity.destroy_all_expired
end
