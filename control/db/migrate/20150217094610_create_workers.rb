class CreateWorkers < ActiveRecord::Migration
  def change
    create_table :workers do |t|
      t.string :title
      t.string :address

      t.timestamps null: false
    end
  end
end
