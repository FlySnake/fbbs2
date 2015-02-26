class CreateFullVersions < ActiveRecord::Migration
  def change
    create_table :full_versions do |t|
      t.references :base_version, index: true
      t.references :build_number, index: true

      t.timestamps null: false
    end
    add_foreign_key :full_versions, :base_versions
    add_foreign_key :full_versions, :build_numbers
    
    add_reference :build_jobs, :full_version, index: true
    add_foreign_key :build_jobs, :full_versions
    
  end
end
