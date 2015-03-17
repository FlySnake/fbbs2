class RemoveForeignKeyToNotifyUserFromBuildJob < ActiveRecord::Migration
  def up
    remove_foreign_key :build_jobs, :notify_user_id
    change_column_null :build_jobs, :notify_user_id, true
  end
  
  def down
    add_foreign_key :build_jobs, :users, column: :notify_user_id
    change_column_null :build_jobs, :notify_user_id, false
  end
end
