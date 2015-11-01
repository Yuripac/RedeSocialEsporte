class Group < ActiveRecord::Base

  has_many :members, dependent: :destroy
  has_many :users, through: :members, dependent: :destroy

  validates_presence_of :name, :description, :sport

  def owner
    members.where(owner: true).first.user
  end
end
