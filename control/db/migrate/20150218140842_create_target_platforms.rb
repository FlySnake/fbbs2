class CreateTargetPlatforms < ActiveRecord::Migration
  def change
    create_table :target_platforms do |t|
      t.string :title, null: false, :limit => 512
      t.references :worker, index: true
      t.timestamps null: false
    end
    add_foreign_key :target_platforms, :workers
  end
end
