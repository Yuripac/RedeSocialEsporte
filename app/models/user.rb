class User < ActiveRecord::Base

  has_many :memberships
  has_many :membership_groups, through: :memberships, source: :group

  has_many :admin_memberships, ->{ where(admin: true) }, class_name: "Membership"
  has_many :groups, through: :admin_memberships, source: :group

  has_many :participations
  has_many :participation_activities, through: :participations, source: :activity

  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  belongs_to :sport

  validates_presence_of :uid, :name, :email, :provider

  before_create do |user|
    user.api_key = user.generate_api_key
  end

  def self.find_or_initialize_with_omniauth(auth)
    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    user.assign_attributes(name: auth.info.name, email: auth.info.email)
    user
  end

  def self.find_or_initialize_with_api(data)
    user = find_or_initialize_by(provider: "facebook", uid: data["id"])
    user.assign_attributes(name: data["name"], email: data["email"])
    user
  end

  #---------------------DATA FROM SOCIAL MIDIA-----------------------------
  def self.facebook(access_token)
    koala = Koala::Facebook::API.new(access_token)
    koala.get_object("me", fields: ["email", "name"])
  end
  #-----------------------------------------------------------------------

  def generate_api_key
    loop  do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end

end
