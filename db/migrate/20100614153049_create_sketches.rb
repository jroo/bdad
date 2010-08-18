class CreateSketches < ActiveRecord::Migration
  def self.up
    create_table :sketches do |t|
      t.string :title
      t.integer :user_id
      t.integer :district_id
      t.timestamps
    end
  end

  def self.down
    drop_table :sketches
  end
end
