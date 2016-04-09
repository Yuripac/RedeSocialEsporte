class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :address, :date
end
