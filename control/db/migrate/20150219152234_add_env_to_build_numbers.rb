class AddEnvToBuildNumbers < ActiveRecord::Migration
  def change
    add_column :build_numbers, :enviroment_id, :integer, references: :enviroments
    add_index :build_numbers, :enviroment_id
    add_foreign_key :build_numbers, :enviroments
  end
end
