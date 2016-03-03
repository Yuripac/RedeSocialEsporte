class User < ActiveRecord::Base

  has_many :members, dependent: :destroy

  has_many :groups, through: :members, dependent: :destroy

  has_many :created_groups, class_name: "Group", foreign_key: "user_id", dependent: :destroy

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
    user.assign_attributes(name: data["name"],email: data["email"])
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
