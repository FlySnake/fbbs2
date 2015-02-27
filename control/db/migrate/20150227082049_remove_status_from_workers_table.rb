class RemoveStatusFromWorkersTable < ActiveRecord::Migration
  def up
    remove_column :workers, :status
  end
  
  def down
    add_column :workers, :status, :integer, null: false, default: 0
  end
end
