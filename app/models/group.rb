class Group < ActiveRecord::Base

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  has_one  :owner_membership, ->{ where(owner: true) }, class_name: "Membership"
  has_one  :owner, through: :owner_membership, source: :user

  has_one  :activity            , dependent: :destroy
  has_many :performed_activities, dependent: :destroy

  belongs_to :sport

  validates_presence_of :name, :description, :sport, :owner

  def owned_by?(user)
    owner == user
  end

end
