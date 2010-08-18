class AddStateFipsToDistrict < ActiveRecord::Migration
  def self.up
    add_column :districts, :state_fips, :string, :limit => 2
    
  end

  def self.down
    remove_column :districts, :state_fips
  end
end
