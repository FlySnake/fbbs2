class AddPersonalizationToUser < ActiveRecord::Migration
  def change
    add_column :users, :background_image, :string
    add_column :users, :properties, :text
  end
end
