class Sport < ActiveRecord::Base
  validates_presence_of :name

  has_many :users
  has_many :groups
end
