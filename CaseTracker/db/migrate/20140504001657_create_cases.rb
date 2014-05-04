class CreateCases < ActiveRecord::Migration
  def change
    create_table :cases do |t|
      t.integer :point_id, :limit => 8
      t.integer :category_id
      t.string :request_details
      t.integer :request_type_id
      t.integer :status_id
      t.datetime :updated
      t.string :media_url
      t.integer :neighborhood_id
      t.integer :sf_case_id, :limit => 8
      t.integer :responsible_agency_id
      t.datetime :opened
      t.integer :source_id
      t.string :address

      t.timestamps
    end

    add_index :cases, :point_id
    add_index :cases, :category_id
    add_index :cases, :request_type_id
    add_index :cases, :status_id
    add_index :cases, :neighborhood_id
    add_index :cases, :responsible_agency_id
    add_index :cases, :source_id
    add_index :cases, :sf_case_id, :unique => true
  end
end
