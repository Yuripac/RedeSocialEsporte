class Group < ActiveRecord::Base

  has_many :members, dependent: :destroy
  has_many :users, through: :members

  belongs_to :user

  belongs_to :sport

  validates_presence_of :name, :description, :user, :sport

  after_create do |group|
    member = Member.new(user: group.user, group: group)
    member.save
  end

  def owner?(_user)
    user == _user
  end

end
