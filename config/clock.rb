require 'clockwork'
require './config/boot'
require './config/environment'


module Clockwork

  every(1.hour, 'fetch.all') do
    puts "fetching the fetchs!"
    User.all.pluck(:id).each do |id|
      FetchesWorkers.perform_async(id)
    end
  end


  every(1.minute, 'fetch.facebook') do
    User.all.each do |user|
      FetchesPhotos.new(user).fetch_facebook if user.facebook?
    end
  end

end
