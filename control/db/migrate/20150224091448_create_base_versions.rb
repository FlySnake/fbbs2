class CreateBaseVersions < ActiveRecord::Migration
  def change
    create_table :base_versions do |t|
      t.string :name, null: false, limit: 128

      t.timestamps null: false
    end
  end
end
