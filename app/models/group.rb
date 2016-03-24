class Group < ActiveRecord::Base

  has_many :memberships, dependent: :delete_all
  has_many :members, through: :memberships, source: :user

  has_many :admins, ->{ Membership.management }, through: :memberships, source: :user

  has_one  :activity            , dependent: :destroy
  has_many :performed_activities, dependent: :destroy

  belongs_to :sport

  validates_presence_of :name, :description, :sport, :admins

  def managed_by?(user)
    self.admins.include?(user)
  end

end
