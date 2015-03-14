class RemoveForeignKeyToWorkers < ActiveRecord::Migration
  def up
    remove_foreign_key :build_jobs, :workers
  end
  
  def down
    add_foreign_key :build_jobs, :workers
  end
end
