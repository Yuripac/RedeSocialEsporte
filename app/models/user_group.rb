class UserGroup < ActiveRecord::Base
  has_many :user
  has_many :user_group
end
