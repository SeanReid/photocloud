class PagesController < ApplicationController
  def photos

    require 'flickraw'

    FlickRaw.api_key=ENV["FLICKR_API_KEY"]
    FlickRaw.shared_secret=ENV["FLICKR_SECRET"]

    id = current_user.connections.find_by(provider: 'flickr').uid
    @photos = flickr.photos.search(:user_id => id)
  end
end
