class CreateHomePageContents < ActiveRecord::Migration
  def change
    create_table :home_page_contents do |t|
      t.string :title, null: false, limit: 1024
      t.string :link, null: true, limit: 4096
      
      t.timestamps null: false
    end
  end
end
