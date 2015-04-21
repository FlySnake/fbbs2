class CreateTestsExecutors < ActiveRecord::Migration
  def change
    create_table :tests_executors do |t|
      t.string :title, limit: 1024, null: false, default: ""
      add_reference :enviroments, :tests_executor, index: true

      t.timestamps null: false
    end
  end
end
