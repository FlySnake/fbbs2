class AddEnabledToWorker < ActiveRecord::Migration
  def change
    add_column :workers, :disabled, :boolean, null: false, default: false
  end
end
