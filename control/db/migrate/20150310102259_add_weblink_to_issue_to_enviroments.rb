class AddWeblinkToIssueToEnviroments < ActiveRecord::Migration
  def change
    add_column :enviroments, :weblink_to_issue, :string, limit: 4096, null: true
  end
end
