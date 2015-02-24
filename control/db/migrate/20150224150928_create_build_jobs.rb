class CreateBuildJobs < ActiveRecord::Migration
  def change
    create_table :build_jobs do |t|
      t.references :branch, index: true, null: false
      t.references :base_version, index: true, null: false
      t.references :enviroment, index: true, null: false
      t.references :target_platform, index: true, null: false
      t.integer :notify_user_id, index: true, null: false
      t.integer :started_by_user_id, index: true, null: false
      t.string :comment, null: false, default: ""
      t.integer :status, null: false

      t.timestamps null: false
    end
    add_foreign_key :build_jobs, :banches
    add_foreign_key :build_jobs, :base_versions
    add_foreign_key :build_jobs, :enviroment
    add_foreign_key :build_jobs, :target_platforms
    add_foreign_key :build_jobs, :notify_user_id
    add_foreign_key :build_jobs, :notify_user_id
  end
end
