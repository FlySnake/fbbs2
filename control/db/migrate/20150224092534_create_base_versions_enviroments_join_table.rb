class CreateBaseVersionsEnviromentsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :base_versions, :enviroments, column_options: {null: true} do |t|
      t.index :base_version_id
      t.index :enviroment_id
    end
  end
end
