class CreateTestsBuildJobsRuns < ActiveRecord::Migration
  def change
    create_table :tests_build_jobs_runs do |t|
      t.references :build_job, index: true, foreign_key: true
      t.references :tests_result, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
