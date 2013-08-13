class AddOrderIndexToTasks < ActiveRecord::Migration

  def change
    add_column :tasks, :order_index, :float
    add_index :tasks, [:user_id, :order_index], unique: true
  end

end
