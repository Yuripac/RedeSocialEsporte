class Membership < ActiveRecord::Base

  belongs_to :user
  belongs_to :group

  scope :ownership, ->{ where(owner: true) }

  validates_presence_of :user, :group
  validates_uniqueness_of :user_id, scope: :group_id,
    message: "Already is a member"

  after_destroy :destroy_group_if_user_is_owner

  private

  def destroy_group_if_user_is_owner
    self.group.destroy if self.owner
  end

end
