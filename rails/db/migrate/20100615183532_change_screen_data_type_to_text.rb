class ChangeScreenDataTypeToText < ActiveRecord::Migration
  def self.up
    change_column :sketches, :screen_data, :text
  end

  def self.down
    change_column :sketches, :screen_data, :string
  end
end
