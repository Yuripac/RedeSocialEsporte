module Api::V1::VerifyGroupOwner
  extend ActiveSupport::Concern

  included do
    before_action :verify_group_owner, only: [:update, :destroy]
  end

  def verify_group_owner
    failure(error: "User isn't authorized to do that.") unless @group.owned_by?(@user)
  end
end
