require 'flickraw'
require 'dropbox_sdk'

class FetchesPhotos

  attr_reader :current_user

  def initialize(user)
    @current_user = user
  end

  def fetch_all
    fetch_facebook if current_user.facebook?
    fetch_flickr if current_user.flickr?
    fetch_dropbox if current_user.dropbox?
  end

  def fetch_facebook
    fb = Koala::Facebook::API.new(current_user.facebook.token)
    @fb_photos = fb.get_connections("me","albums", :fields => "name, photos.fields(source)")
    @fb_photos.each do |albums|
      albums["photos"]["data"].each do |photo|
        url = photo["source"]
        taken = DateTime.parse photo["created_time"]
        id = photo["id"]
        photo = current_user.facebook.photos.find_by uid: id

        if photo
          photo.update url: url, taken_date: taken
        else
          current_user.facebook.photos.create! uid: id, taken_date: taken, url: url
        end
      end
    end
  end

  def fetch_flickr

    FlickRaw.api_key=ENV["FLICKR_API_KEY"]
    FlickRaw.shared_secret=ENV["FLICKR_SECRET"]

    flickr_uid = current_user.flickr.uid
    @flickr_photos = flickr.photos.search user_id: flickr_uid, per_page: 50
    @flickr_photos.photo.each do |flickr_photo|
      uid = flickr_photo.id
      info = flickr.photos.getInfo photo_id: flickr_photo.id
      taken = DateTime.parse info["dates"]["taken"]
      url = FlickRaw.url_b(info)
      photo = current_user.flickr.photos.find_by uid: uid

      if photo
        photo.update url: url, taken_date: taken
      else
        current_user.flickr.photos.create! uid: uid, taken_date: taken, url: url
      end
    end
  end

  def fetch_dropbox

    db_session = DropboxSession.new ENV["DB_KEY"], ENV["DB_SECRET"]
    db_creds= {'token' => current_user.dropbox.token, 'secret' => current_user.dropbox.secret} ## we don't have a place for the "secret"
    db_session.set_access_token db_creds["token"], db_creds["secret"]

    db = DropboxClient.new(db_session)
    db.extend DropBoxClientMods

    @db_photos = db.metadata("/Camera Uploads", 50, true, nil, nil, false)
    @db_photos = @db_photos["contents"].map do |photo|
      url = db.media(photo["path"])["url"]

      if photo['photo_info']['time_taken'].nil?
        taken = DateTime.parse photo['client_mtime']
      else
        taken = DateTime.parse photo['photo_info']['time_taken']
      end

      id = photo['rev']
      photo = current_user.dropbox.photos.find_by uid: id

      if photo
        photo.update url: url, taken_date: taken
      else
        current_user.dropbox.photos.create! uid: id, taken_date: taken, url: url
      end
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
