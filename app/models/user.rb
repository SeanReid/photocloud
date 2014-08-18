class User < ActiveRecord::Base
  has_many :connections
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:flickr, :facebook, :dropbox]

  def flickr
    connections.find_by(provider: 'flickr')
  end

  def flickr?
    flickr.present?
  end

end
