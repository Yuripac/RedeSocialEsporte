class Activity < ActiveRecord::Base

  belongs_to :group

  has_one :sport, through: :group

  validates_presence_of :latitude, :longitude, :address, :group
end
