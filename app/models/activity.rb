class Activity < ActiveRecord::Base

  belongs_to :group

  has_one :sport, through: :group

  validates_presence_of :latitude, :longitude, :address, :date, :group

  scope :expired, ->{ where(["date < ?", Time.zone.now]) }

  def expired?
    date < Time.zone.now
  end

  def self.move_all_expired
    activities = expired
    performed_activities = activities.map do |a|
      performed_activity = a.attributes
      performed_activity["performed_at"] = performed_activity.delete "date"
      performed_activity
    end

    ActiveRecord::Base.transaction do
      PerformedActivity.create(performed_activities)
      activities.destroy_all
    end
  end

end
