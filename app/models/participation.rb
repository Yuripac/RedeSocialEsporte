class Participation < ActiveRecord::Base

  belongs_to :user
  belongs_to :activity

  validates_presence_of :user, :activity
  validates_uniqueness_of :user_id, scope: :activity_id,
    message: "Already participates"
  validate :user_must_be_member_of_the_group

  private

  def user_must_be_member_of_the_group
    unless self.activity.group.members.include?(user)
      self.errors.add(:user, "Must be a member of the group")
    end
  end

end
