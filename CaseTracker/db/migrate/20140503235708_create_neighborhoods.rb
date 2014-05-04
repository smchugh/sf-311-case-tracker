class CreateNeighborhoods < ActiveRecord::Migration
  def change
    create_table :neighborhoods do |t|
      t.string :name
      t.integer :supervisor_district

      t.timestamps
    end

    add_index :neighborhoods, :name, :unique => true
  end
end
