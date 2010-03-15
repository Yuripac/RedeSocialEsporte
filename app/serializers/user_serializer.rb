class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :uid, :sport
  has_one :sport
end
