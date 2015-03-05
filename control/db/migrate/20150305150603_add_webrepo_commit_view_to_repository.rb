class AddWebrepoCommitViewToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :weblink_to_commit, :string, limit: 4096, null: true
  end
end
