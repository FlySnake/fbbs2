class AddRepoBreferenceAndRanchesFilterToEnviroment < ActiveRecord::Migration
  def change
    add_reference :enviroments, :repository, index: true
    add_foreign_key :enviroments, :repositories
    add_column :enviroments, :branches_filter, :string, default: "", limit: 2048
  end
end
