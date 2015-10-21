class User < ActiveRecord::Base
  has_many :groups
  belongs_to :user_group

  validates_presence_of :name, :age, :favorite_sport
end