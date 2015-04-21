class AddTestsParams < ActiveRecord::Migration
  def change
    add_column :tests_executors, :run_params, :string, null: false, default: ""
    add_column :tests_executors, :artefact_name, :string, null: false, default: ""
  end
end
