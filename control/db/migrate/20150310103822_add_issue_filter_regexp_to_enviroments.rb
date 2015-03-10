class AddIssueFilterRegexpToEnviroments < ActiveRecord::Migration
  def change
    add_column :enviroments, :issue_regex, :string, limit: 256, null: false, default: ""
  end
end
