class Activity < ActiveRecord::Base

  has_many :participations, dependent: :delete_all
  has_many :participants, through: :participations, source: :user

  belongs_to :group
  delegate :sport, :owner, :owned_by?, to: :group

  scope :expired, ->{ where(["date < ?", Time.zone.now]) }

  validates_presence_of :latitude, :longitude, :address, :date, :group

  after_create { |activity| activity.participants << activity.group.owner }

  before_destroy :move_expired_activity

  def expired?
    self.date < Time.zone.now
  end

  def to_performed_activity
    performed_activity = self.attributes
    performed_activity["performed_at"] = performed_activity.delete("date")
    performed_activity
  end

  def self.destroy_all_expired
    activities = self.expired

    ActiveRecord::Base.transaction { activities.destroy_all }
  end

  private

  def move_expired_activity
    PerformedActivity.create(self.to_performed_activity) if self.expired?
  end

end
