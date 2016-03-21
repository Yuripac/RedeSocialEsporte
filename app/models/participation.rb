class Participation < ActiveRecord::Base

  belongs_to :user
  belongs_to :activity

  validates_presence_of :user, :activity
  validates_uniqueness_of :user_id, scope: :activity_id
  validate :user_must_be_member_of_the_group

  after_destroy :destroy_activity_if_user_is_owner

  private

  def user_must_be_member_of_the_group
    unless self.activity.group.members.include?(user)
      self.errors.add(:user, "Must be a member of the group")
    end
  end

  def destroy_activity_if_user_is_owner
     self.activity.destroy if self.activity.owned_by?(self.user)
  end

end
