class CreateIssueTrackers < ActiveRecord::Migration
  def change
    create_table :issue_trackers do |t|
      t.string :title, null: false, limit: 1024
      t.string :weblink, null: false, limit: 4096
      t.string :regex, null: false, limit: 4096
      

      t.timestamps null: false
    end
    add_reference :enviroments, :issue_tracker, index: true
    add_foreign_key :enviroments, :issue_trackers
    
  end
end
