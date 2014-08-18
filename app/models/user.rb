class User < ActiveRecord::Base
  has_many :connections
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:flickr, :facebook, :dropbox]

  def flickr
    connections.find_by provider: 'flickr'
  end

  def flickr?
    flickr.present?
  end

  def facebook
    connections.find_by provider: 'facebook'
  end

  def facebook?
    facebook.present?
  end

  def dropbox
    connections.find_by provider: 'dropbox'
  end

  def dropbox?
    dropbox.present?
  end

end
