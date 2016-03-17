class Membership < ActiveRecord::Base

  belongs_to :user
  belongs_to :group

  scope :ownership, ->{ where(owner: true) }

  validates_presence_of :user, :group
  validates_uniqueness_of :user_id, scope: :group_id

  # before_destroy :delete_group_if_user_is_owner

  # private

  # def delete_group_if_user_is_owner
  #   self.group.delete if self.group.owned_by?(self.user)
  # end

end
