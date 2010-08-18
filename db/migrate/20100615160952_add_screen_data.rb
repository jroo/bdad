class AddScreenData < ActiveRecord::Migration
  def self.up
    add_column :sketches, :screen_data, :string
  end

  def self.down
    remove_column :sketches, :screen_data
  end
end
