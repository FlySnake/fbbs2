class AddPriorityToWorker < ActiveRecord::Migration
  def change
    add_column :workers, :priority, :integer, null: false, default: 0
  end
end
