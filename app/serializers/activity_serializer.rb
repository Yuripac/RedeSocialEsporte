class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :address, :date, :participants_count

  def participants_count
    object.participants.count
  end
end
