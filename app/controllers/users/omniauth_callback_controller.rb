class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def flickr
    # get values from request
    deets = request.env["omniauth.auth"]
    uid = deets["uid"]
    name = deets.fetch("info").fetch("name")
    token = deets.fetch("credentials").fetch("token")
    # find/create user

    connection = Connection.find_by uid: uid
    if connection
      connection.update(name: name, token: token)
    end
    # sign_in_and_redirect
    sign_in_and_redirect connection, :event => :authentication
    set_flash_message(:notice, :success, :kind => "Flickr") if is_navigational_format?
  end
end
