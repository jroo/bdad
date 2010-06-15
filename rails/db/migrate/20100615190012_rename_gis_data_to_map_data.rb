class RenameGisDataToMapData < ActiveRecord::Migration
  def self.up
    rename_column :sketches, :gis_data, :map_data
  end

  def self.down
    rename_column :sketches, :map_data, :gis_data
  end
end
