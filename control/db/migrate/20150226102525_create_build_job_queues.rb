class CreateBuildJobQueues < ActiveRecord::Migration
  def change
    create_table :build_job_queues do |t|
      t.references :build_job, index: true

      t.timestamps null: false
    end
    add_foreign_key :build_job_queues, :build_jobs
  end
end
