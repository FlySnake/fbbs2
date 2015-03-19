class AddDeletedToBranches < ActiveRecord::Migration
  def change
    add_column :branches, :deleted, :boolean, default: false, null: false
  end
end
