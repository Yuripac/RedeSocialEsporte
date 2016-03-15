class PerformedActivity < ActiveRecord::Base

  belongs_to :group

  has_one :sport, through: :group

  validates_presence_of :latitude, :longitude, :address, :performed_at, :group

end
