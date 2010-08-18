class AddOffsetsToScreenData < ActiveRecord::Migration
  def self.up
      add_column :screen_datas, :offset_x, :integer
      add_column :screen_datas, :offset_y, :integer
  end

  def self.down
      remove_column :screen_datas, :offset_x, :integer
      remove_column :screen_datas, :offset_y, :integer
  end
end
