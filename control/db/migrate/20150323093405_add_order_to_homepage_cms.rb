class AddOrderToHomepageCms < ActiveRecord::Migration
  def change
    add_column :home_page_contents, :position, :integer, null: false, default: 0
  end
end
