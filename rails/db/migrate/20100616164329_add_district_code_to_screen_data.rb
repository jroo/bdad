class AddDistrictCodeToScreenData < ActiveRecord::Migration
  def self.up
    add_column :screen_datas, :district_code, :string, :limit => 4
  end

  def self.down
    drop_column :screen_datas, :district_code
  end
end
