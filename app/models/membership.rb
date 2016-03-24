class Membership < ActiveRecord::Base

  belongs_to :user
  belongs_to :group

  scope :management, ->{ where(admin: true) }

  validates_presence_of :user, :group
  validates_uniqueness_of :user_id, scope: :group_id,
    message: "Already is a member"

  after_destroy :destroy_group_if_has_no_admin

  private

  def destroy_group_if_has_no_admin
    group.destroy if group.admins.empty?
  end

end
