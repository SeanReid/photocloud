require 'dropbox_sdk'

class PagesController < ApplicationController

  before_action :check_for_flickr, only: [:photos]

  def photos

    require 'flickraw'

    FlickRaw.api_key=ENV["FLICKR_API_KEY"]
    FlickRaw.shared_secret=ENV["FLICKR_SECRET"]

    id = current_user.flickr.uid
    @photos = flickr.photos.search user_id: id

    fb = Koala::Facebook::API.new(current_user.facebook.token)
    @fb_photos = fb.get_connections("me","albums", :fields => "name, photos.fields(source)")


    db_session = DropboxSession.new ENV["DB_KEY"], ENV["DB_SECRET"]
    db_creds= {"token"=>"3pbq3ydr6guft8h4", "secret"=>"0c5bhnpagl3wt8x"} ## should get from user
    db_session.set_access_token db_creds["token"], db_creds["secret"]


    db = DropboxClient.new(db_session)

    @db_photos = db.metadata("/Photos")["contents"].take(5).map do |item|
      db.thumbnail(item["path"], "l")
    end

  end

  def check_for_flickr
    unless current_user.flickr?
      redirect_to root_path, notice: "Please connect to Flickr"
    end
  end
end
