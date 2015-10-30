class Member < ActiveRecord::Base

  belongs_to :user
  belongs_to :group

  validates_presence_of :user_id, :group_id
  validates_inclusion_of :owner, in: [true, false]
end
