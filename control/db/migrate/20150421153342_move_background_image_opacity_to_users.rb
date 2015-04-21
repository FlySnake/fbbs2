class MoveBackgroundImageOpacityToUsers < ActiveRecord::Migration
  def up
    add_column :users, :background_image_opacity, :string, null: false, default: '0.5'
    remove_column :users, :properties
  end
  
  def down
    remove_column :users, :background_image_opacity
    add_column :users, :properties, :text
  end
end
