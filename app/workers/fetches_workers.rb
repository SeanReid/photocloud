class FetchesWorkers
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    FetchesPhotos.new(user).fetch_all
  end
end
