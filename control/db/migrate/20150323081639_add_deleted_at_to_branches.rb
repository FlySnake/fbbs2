class AddDeletedAtToBranches < ActiveRecord::Migration
  def up
    add_column :branches, :deleted_at, :datetime
    add_index :branches, :deleted_at
    remove_column :branches, :deleted
  end
  
  def down
    remove_column :branches, :deleted_at
    add_column :branches, :deleted, :boolean, default: false, null: false
  end
end
