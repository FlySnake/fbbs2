class AddTargetPlatformsOrderToEnviroment < ActiveRecord::Migration
  def change
    add_column :enviroments, :target_platforms_order, :text
  end
end
