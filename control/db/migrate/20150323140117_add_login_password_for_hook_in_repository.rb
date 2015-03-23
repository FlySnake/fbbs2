class AddLoginPasswordForHookInRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :hook_login, :string, limit: 128
    add_column :repositories, :hook_password, :string, limit: 128
  end
end
