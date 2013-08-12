class TaskSerializer < ActiveModel::Serializer

  attributes :id, :user_id, :name, :state, :description,
    :due_at, :order_index, :created_at, :updated_at

end
