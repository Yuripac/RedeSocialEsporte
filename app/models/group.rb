class Group < ActiveRecord::Base

  has_many :members
  has_many :users, through: :members

  validates_presence_of :name, :description, :sport

  def owner
    members.where(owner: true).first.user
  end
end
