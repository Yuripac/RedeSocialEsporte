class User < ActiveRecord::Base

  has_many :members
  has_many :groups, through: :members

  validates_presence_of :email, :name, :password
  validates_uniqueness_of :email

  def password
    @password
  end

  def password=(new_password)
    @password = new_password
    self.encrypted_password = BCrypt::Password.create(@password)
  end


  def valid_password?(password_to_validate)
    BCrypt::Password.new(encrypted_password) == password_to_validate
  end

end