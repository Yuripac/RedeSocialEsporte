class Activity < ActiveRecord::Base

  belongs_to :group

  has_one :sport, through: :group

  validates_presence_of :latitude, :longitude, :address, :date, :group

  scope :expired, ->{ where(["date < ?", Time.zone.now]) }

  before_destroy do |activity|
    if activity.expired?
      PerformedActivity.create(activity.to_performed_activity)
    end
  end

  def expired?
    self.date < Time.zone.now
  end

  def to_performed_activity
    performed_activity = self.attributes
    performed_activity["performed_at"] = performed_activity.delete "date"
    performed_activity
  end

  def self.destroy_all_expired
    activities = self.expired

    ActiveRecord::Base.transaction do
      activities.destroy_all
    end
  end

end
