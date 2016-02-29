class User < ActiveRecord::Base

  has_many :members, dependent: :destroy

  has_many :groups, through: :members, dependent: :destroy

  has_many :created_groups, class_name: "Group", foreign_key: "user_id", dependent: :destroy

  validates_presence_of :uid, :name, :email, :provider

  before_create do |user|
    user.api_key = user.generate_api_key
  end

  def self.find_or_create_with_omniauth(auth)
    user = find_or_create_by(provider: auth.provider, uid: auth.uid)
    user.assign_attributes({
      name: auth.info.name,
      email: auth.info.email,
    })
    user
  end

  def self.find_or_create_with_api(id, data)
    user = find_or_create_by(provider: data[:provider], uid: id)
    user.assign_attributes({
      name: data[:name],
      email: data[:email]
    })
    user
  end

  #---------------------DATA FROM SOCIAL MIDIA-----------------------------
  def self.data_from_facebook(access_token)
    Koala::Facebook::API.new(access_token).get_object("me")
  end

  def self.data_from(opts = {})
    begin
      send("data_from_#{opts[:provider]}", opts[:access_token])
    rescue NoMethodError
      {}
    end
  end
  #-----------------------------------------------------------------------
  def generate_api_key
    loop  do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end

end
