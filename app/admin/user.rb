ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
  show title: :name do
    panel "Groups" do
      table_for(user.groups) do
        column("ID")         {|group| link_to(group.id, admin_group_path(group))}
        column("Name")       {|group| group.name}
        column("Sport")      {|group| group.sport}
        column("Created at") {|group| pretty_format(group.created_at)}
        column("Owner")      {|group| }
      end
    end
  end

  sidebar "User Details", only: :show do
    attributes_table_for user do
      row("Total Create Groups") {user.groups.count}
      row("Total Groups Participating") {}#user.participaring.count - user.groups.count
    end
  end


end
