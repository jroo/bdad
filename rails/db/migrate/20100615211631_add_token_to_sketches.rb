class AddTokenToSketches < ActiveRecord::Migration
  def self.up
    add_column :sketches, :token, :string, :limit => 40
  end

  def self.down
    remove_column :sketches, :token
  end
end
