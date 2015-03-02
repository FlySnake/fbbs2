class CreateReleaseVersions < ActiveRecord::Migration
  def change
    create_table :release_versions do |t|
      t.string :name
      t.timestamps null: false
    end
    
    add_reference :full_versions, :release_version, index: true
    add_foreign_key :full_versions, :release_versions
    
  end
end
