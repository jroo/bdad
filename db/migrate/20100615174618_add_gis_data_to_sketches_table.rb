class AddGisDataToSketchesTable < ActiveRecord::Migration
  def self.up
    add_column :sketches, :gis_data, :multi_polygon
  end

  def self.down
    remove_column :sketches, :gis_data
  end
end
