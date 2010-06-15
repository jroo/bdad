class CreateScreenDatas < ActiveRecord::Migration
  def self.up
    create_table :screen_datas do |t|
      t.text :value
      t.string :token, :limit => 40
      t.timestamps
    end
  end

  def self.down
    drop_table :screen_datas
  end
end
