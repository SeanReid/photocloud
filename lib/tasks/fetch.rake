namespace :fetch do

  desc 'fetch all photos for all users'
  task :fetch => :environment do
    puts "Importing"
    User.all.pluck(:id).each do |id|

      FetchesWorkers.perform_async(id) 
    end
  end
end
