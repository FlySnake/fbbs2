class AddBuildNumbersUrlToBuildJob < ActiveRecord::Migration
  def change
    add_column :build_jobs, :generate_build_numbers_url, :string, null: false, default: ""
  end
end
