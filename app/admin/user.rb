ActiveAdmin.register User do
  %i(last_active).each do |filter_name|
    filter filter_name
  end

  index do
    selectable_column
    column :last_active
    actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
