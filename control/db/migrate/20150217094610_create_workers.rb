class CreateWorkers < ActiveRecord::Migration
  def change
    create_table :workers do |t|
      t.string :title, :null => false
      t.string :address, :null => false

      t.timestamps null: false
    end
  end
end
