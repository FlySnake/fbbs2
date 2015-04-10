class AddRunTestsToBuildJob < ActiveRecord::Migration
  def change
    add_column :build_jobs, :run_tests, :boolean, null: false, default: false
    add_column :enviroments, :tests_enabled_by_default, :boolean, null: false, default: false
  end
end
