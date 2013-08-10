class AddOrderIndexToTasks < ActiveRecord::Migration

  def change
    add_column :tasks, :order_index, :float
  end

end
