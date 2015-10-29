class MembersController < ApplicationController

  def join
    owner = params[:owner] || false
    group = Group.find(params[:group])

    @member = Member.new(user: current_user, group: group, owner: owner)

    if @member.save
      flash[:notice] ||= "Joined"
      redirect_to groups_path
    else
      redirect_to groups_path, alert: "You can't join!"
    end
  end

  def index
    @groups = []

    members = Member.where(user_id: current_user.id)

    members.each do |member|
      @groups << member.group
    end

    @groups
  end

end