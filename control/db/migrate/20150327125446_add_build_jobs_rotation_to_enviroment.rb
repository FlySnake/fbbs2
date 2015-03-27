class AddBuildJobsRotationToEnviroment < ActiveRecord::Migration
  def change
    add_column :enviroments, :delete_build_jobs_older_than, :integer, null: false, default: 0
  end
end
