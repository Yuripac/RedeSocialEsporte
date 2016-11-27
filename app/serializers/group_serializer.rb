class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :sport, :admin_ids, :activity, :members_count
  has_one :sport
  has_one :activity

  def members_count
    object.members.count
  end
end
