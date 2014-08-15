class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def flickr
    # get values from request
    deets = request.env["omniauth.auth"]
    uid = deets["uid"]
    name = deets.fetch("info").fetch("name")
    token = deets.fetch("credentials").fetch("token")
    # find/create user

    connection = Connection.find_by(uid: uid, provider: "flickr")
    if connection
      connection.update(name: name, token: token)
    else
      connection = Connection.create!(uid: uid, name: name, token: token, provider: "flickr")
    end
    # sign_in_and_redirect
    set_flash_message(:notice, :success, :kind => "Flickr") if is_navigational_format?
  end
end
