class AddWorkerStatus < ActiveRecord::Migration
  def change
    add_column :workers, :status, :integer, null: false, default: 0
  end
end
