class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :sport, :admin_ids, :activity
  has_one :sport
  has_one :activity
end
