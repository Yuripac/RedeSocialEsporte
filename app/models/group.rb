class Group < ActiveRecord::Base

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  belongs_to :user
  belongs_to :sport

  validates_presence_of :name, :description, :user, :sport

  def owner?(_user)
    user == _user
  end

end
