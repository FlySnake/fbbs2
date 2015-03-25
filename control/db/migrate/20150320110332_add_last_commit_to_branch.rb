class AddLastCommitToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :last_commit_identifier, :string, null: false, default: ""
  end
end
