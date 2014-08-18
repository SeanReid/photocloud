class PagesController < ApplicationController

  before_action :check_for_flickr, only: [:photos]

  def photos

    require 'flickraw'

    FlickRaw.api_key=ENV["FLICKR_API_KEY"]
    FlickRaw.shared_secret=ENV["FLICKR_SECRET"]

    id = current_user.flickr.uid
    @photos = flickr.photos.search user_id: id

    fb = Koala::Facebook::API.new("CAAXs6WFBgvoBADpiMZBX3Dj7hIZBoGtNdzLgL9zL9J6T5t59JKYjyDIzwtg2Xe6SkxELZB2g8d7CTB8ZB7VTxFWTKLItiz6Rh8f5o5ffEbcNS1zMPvbG4yRhVDhcedKOnMVLBEDwwvyYsQfQop9F3zhmvnzZC4QZAzqXWhhMZBmXQ0wZBpDytsr3Ce0aztGdrxvYp4oHyqPAkcV9yXO9XoOc")
    @fb_photos = fb.get_connections("me","albums", :fields => "name, photos.fields(source)")
  end

  def check_for_flickr
    unless current_user.flickr?
      redirect_to root_path, notice: "Please connect to Flickr"
    end
  end
end
