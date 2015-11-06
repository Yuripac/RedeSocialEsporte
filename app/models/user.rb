class User < ActiveRecord::Base

  has_many :members, dependent: :destroy
  has_many :groups, through: :members, dependent: :destroy

  has_many :created_groups, class_name: "Group", foreign_key: "user_id", dependent: :destroy

  def self.find_or_create_with_omniauth(auth)
    user = self.find_or_create_by(provider: auth.provider, uid: auth.uid)
    user.assign_attributes({name: auth.info.name, email: auth.info.email, access_token: auth.credentials.token })
    user.save
    user
  end

end