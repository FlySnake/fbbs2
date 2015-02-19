class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.string :name, limit: 512, null: false, index: true
      t.references :repository, index: true

      t.timestamps null: false
    end
    add_foreign_key :branches, :repositories
  end
end
