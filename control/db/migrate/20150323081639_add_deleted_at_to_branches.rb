class AddDeletedAtToBranches < ActiveRecord::Migration
  def up
    add_column :branches, :deleted_at, :datetime
    add_index :branches, :deleted_at
    remove_column :branches, :deleted
    add_index :branches, :name
  end
  
  def down
    remove_column :branches, :deleted_at
    add_column :branches, :deleted, :boolean, default: false, null: false
    remove_index :branches, :name
  end
end
