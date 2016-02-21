class Group < ActiveRecord::Base

  has_many :members, dependent: :destroy
  has_many :users, through: :members

  belongs_to :user

  validates_presence_of :name, :description, :sport, :user_id

  after_create do |group|
    member = Member.new(user: group.user, group: group)
    member.save
  end

end
