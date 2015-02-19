class CreateBuildNumbers < ActiveRecord::Migration
  def change
    create_table :build_numbers do |t|
      t.string :branch, index: true, null: false, limit: 1024
      t.string :commit, null: false, limit: 1024
      t.string :number, null: false, limit: 1024

      t.timestamps null: false
    end
  end
end
