class FixWorkerTargetPlatformAssociation < ActiveRecord::Migration
  def up
    remove_column :target_platforms, :worker_id
    create_join_table :target_platforms, :workers, column_options: {null: true} do |t|
      t.index :target_platform_id
      t.index :worker_id
    end
  end
  
  def down
    drop_table :target_platforms_workers
  end
end
