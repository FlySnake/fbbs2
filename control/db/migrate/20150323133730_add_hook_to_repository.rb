class AddHookToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :hook_enabled, :boolean, null: false, default: false
  end
end
