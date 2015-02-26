class CreateBuildLogs < ActiveRecord::Migration
  def change
    create_table :build_logs do |t|
      t.text :text

      t.timestamps null: false
    end
    add_reference :build_jobs, :build_log, index: true
    add_foreign_key :build_jobs, :build_logs
  end
end
