class RemoveForeignKeyToArtefactsFromBuildJobs < ActiveRecord::Migration
  def up
    remove_foreign_key :build_artefacts, :build_jobs
  end
  
  def down
    add_foreign_key :build_artefacts, :build_jobs
  end
end
