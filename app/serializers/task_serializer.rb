class TaskSerializer < ActiveModel::Serializer

  attributes :user_id, :name, :state, :description,
    :due_at, :created_at, :updated_at

end
