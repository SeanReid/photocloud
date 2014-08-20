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
    db.extend DropBoxClientMods

    @db_photos = db.metadata("/Photos", 10000, true, nil, nil, false)
    @db_photos = @db_photos["contents"].take(6).map do |item|

      db.media(item["path"])["url"]
    end
  end

  def check_for_flickr
    unless current_user.flickr?
      redirect_to root_path, notice: "Please connect to Flickr"
    end
  end


  module DropBoxClientMods
    def metadata(path, file_limit=25000, list=true, hash=nil, rev=nil, include_deleted=false)
      params = {
        "file_limit" => file_limit.to_s,
        "list" => list.to_s,
        "include_deleted" => include_deleted.to_s,
        "hash" => hash,
        "rev" => rev,
        "include_media_info" => true
      }

      response = @session.do_get "/metadata/#{@root}#{format_path(path)}", params
      if response.kind_of? Net::HTTPRedirection
        raise DropboxNotModified.new("metadata not modified")
      end
      Dropbox::parse_response(response)
    end
  end
end
