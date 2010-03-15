class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :address, :date, :group
  has_one :group
end
