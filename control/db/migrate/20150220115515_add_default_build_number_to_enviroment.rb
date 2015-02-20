class AddDefaultBuildNumberToEnviroment < ActiveRecord::Migration
  def change
    add_column :enviroments, :default_build_number, :integer, null: false, default: 0
  end
end
