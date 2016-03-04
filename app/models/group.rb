class Group < ActiveRecord::Base

  has_many :members, dependent: :destroy
  has_many :users, through: :members

  belongs_to :user
  belongs_to :sport

  validates_presence_of :name, :description, :user, :sport

  def owner?(_user)
    user == _user
  end

end
