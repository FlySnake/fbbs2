class CreateTestsResults < ActiveRecord::Migration
  def change
    create_table :tests_results do |t|
      t.string :title, null: false, default: ""
      t.text :data, null: true
      t.references :tests_executor, index: true

      t.timestamps null: false
    end
  end
end
