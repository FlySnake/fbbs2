class AddTestsSupportToWorker < ActiveRecord::Migration
  def change
    add_column :workers, :tests_support, :boolean, null: false, default: false
  end
end
