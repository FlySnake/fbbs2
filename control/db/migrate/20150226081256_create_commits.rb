class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :identifier, null: false
      t.datetime :datetime, null: false
      t.string :message, null: false, default: ""
      t.string :author, null: false, default: ""

      t.timestamps null: false
    end
    add_index :commits, :identifier
    
    add_reference :build_jobs, :commit, index: true
    add_foreign_key :build_jobs, :commits
  end
end
