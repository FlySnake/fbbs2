class RemoveReferencesFromFullVersions < ActiveRecord::Migration
  def up
    remove_column :full_versions, :build_number_id
    remove_column :full_versions, :base_version_id
    add_column :full_versions, :title, :string
  end
  
  def down
    add_reference :full_versions, :build_number
    add_reference :full_versions, :base_version
    remove_column :full_versions, :title
  end
end
