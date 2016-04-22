class Relationship < ActiveRecord::Base

  belongs_to :follower, class_name: "User", foreign_key: 'follower_id'
  belongs_to :followed, class_name: "User", foreign_key: 'followed_id'

  validates_presence_of :follower, :followed
  validates_uniqueness_of :follower_id, scope: :followed_id,
    message: "already follows this user"

  validate :check_follower_and_followed

  def check_follower_and_followed
    if follower == followed
      errors.add(:user, "can't be follower and followed at the same time")
    end
  end

end
