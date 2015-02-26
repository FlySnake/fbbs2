class AddReferenceToWorkerOnBuildJob < ActiveRecord::Migration
  def change
    add_reference :build_jobs, :worker, index: true
    add_foreign_key :build_jobs, :workers
    add_column :build_jobs, :started_at, :datetime, null: true
    add_column :build_jobs, :finished_at, :datetime, null: true
  end
end
