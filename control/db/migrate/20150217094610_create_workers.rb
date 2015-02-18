class CreateWorkers < ActiveRecord::Migration
  def change
    create_table :workers do |t|
      t.string :title, :null => false, :limit => 512
      t.string :address, :null => false, :limit => 512

      t.timestamps null: false
    end
  end
end
