class CreateEnviroments < ActiveRecord::Migration
  def change
    create_table :enviroments do |t|
      t.string :title, index: true, null: false, limit: 1024

      t.timestamps null: false
    end
  end
end
