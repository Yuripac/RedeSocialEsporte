class Group < ActiveRecord::Base

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  has_many :performed_activities, dependent: :destroy

  has_one :activity, dependent: :destroy

  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  belongs_to :sport

  validates_presence_of :name, :description, :owner, :sport

  after_create { |group| group.members << group.owner }

  def owned_by?(user)
    owner == user
  end

end
