ActiveAdmin.register Rpush::Apns::Notification do
  menu label: "Notifications"

  index title: "Notifications" do
    column :delivered
    column :delivered_at
    column :created_at
    column :alert
    column :failed
    column :error_description
  end
end
