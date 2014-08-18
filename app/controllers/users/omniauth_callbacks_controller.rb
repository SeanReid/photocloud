class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def flickr
    # get values from request
    deets = request.env["omniauth.auth"]
    uid = deets["uid"]
    name = deets.fetch("info").fetch("name")
    token = deets.fetch("credentials").fetch("token")
    # find/create user

    connection = current_user.connections.find_by uid: uid, provider: "flickr"
    if connection
      connection.update name: name, token: token
    else
      connection = current_user.connections.create! uid: uid, name: name, token: token, provider: "flickr"
    end
    redirect_to photos_path
    set_flash_message :notice, :success, :kind => "Flickr" if is_navigational_format?
  end

  def facebook
    # get values from request
    deets = request.env["omniauth.auth"]
    uid = deets["uid"]
    name = deets.fetch("info").fetch("name")
    token = deets.fetch("credentials").fetch("token")
    # find/create user

    connection = current_user.connections.find_by uid: uid, provider: "facebook"
    if connection
      connection.update name: name, token: token
    else
      connection = current_user.connections.create! uid: uid, name: name, token: token, provider: "facebook"
    end
    redirect_to photos_path
    set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  end

  def dropbox
    # get values from request
    deets = request.env["omniauth.auth"]
    uid = deets["uid"]
    name = deets.fetch("info").fetch("name")
    token = deets.fetch("credentials").fetch("token")
    binding.pry
    # find/create user

    connection = current_user.connections.find_by uid: uid.to_s, provider: "dropbox"
    if connection
      connection.update name: name, token: token
    else
      connection = current_user.connections.create! uid: uid, name: name, token: token, provider: "dropbox"
    end
    redirect_to photos_path
    set_flash_message(:notice, :success, :kind => "dropbox") if is_navigational_format?
  end
end
