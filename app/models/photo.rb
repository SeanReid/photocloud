class Photo < ActiveRecord::Base
  belongs_to :connection

  validates :taken_date, presence: true
  validates :url, presence: true
  validates :uid, presence: true
end
