module Api::V1::VerifyGroupAdmin
  extend ActiveSupport::Concern

  included do
    before_action :verify_group_admin, only: [:update, :destroy]
  end

  def verify_group_admin
    unless @group.managed_by?(@user)
      failure(error: "User isn't authorized to do that.")
    end
  end
end
