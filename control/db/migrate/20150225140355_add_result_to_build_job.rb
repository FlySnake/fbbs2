class AddResultToBuildJob < ActiveRecord::Migration
  def change
    add_column :build_jobs, :result, :integer, null: false, default: 0
  end
end
