class AddMapDataColumnToScreenData < ActiveRecord::Migration
  def self.up
    add_column :screen_datas, :map_data, :multi_polygon
  end

  def self.down
    remove_column :screen_datas, :map_data
  end
end
