ActiveAdmin.register Invitation do
  index do
    column :id
    column :event_name
    column :invited_user_name
    default_actions
  end

  show do
    attributes_table do
      row :id
      row :event_name
      row :invited_user_name
    end
    active_admin_comments
  end

end