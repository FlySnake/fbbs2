class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :title, null: false, default: "", limit: 512
      t.string :path, null: false, limit: 4096
      t.integer :vcs_type, null: false

      t.timestamps null: false
    end
  end
end
