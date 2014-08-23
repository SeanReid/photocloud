class PagesController < ApplicationController

  before_action :authenticate_user!

  def photos
    @photos = current_user.photos.order("taken_date DESC")
  end

end
