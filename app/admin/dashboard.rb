ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do

      column do
        panel "Recent Groups" do
          table_for Group.order('id desc').limit(10).each do |group|
            column('Name')       {|group| group.name}
            column('Owner')      {|group| link_to(group.user.email, admin_user_path(group.user))}
            column('Sport')      {|group| group.sport}
            column('Created at') {|group| pretty_format(group.created_at)}
          end
        end
      end

      column do
        panel "Recent Users" do
          table_for User.order('id desc').limit(10) do
            column('Name')      {|user| user.name}
            column('Email')     {|user| link_to(user.email, admin_user_path(user))}
            column('Creted at') {|user| pretty_format(user.created_at)}
          end
        end
      end

    end
  end
  #content title: proc{ I18n.t("active_admin.dashboard") } do
    #div class: "blank_slate_container", id: "dashboard_default_message" do
      #span class: "blank_slate" do
        #span I18n.t("active_admin.dashboard_welcome.welcome")
        #small I18n.t("active_admin.dashboard_welcome.call_to_action")
      #end
    #end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  #end # content
end
