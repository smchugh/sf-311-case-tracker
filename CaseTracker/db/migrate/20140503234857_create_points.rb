class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.float :longitude, limit: 53
      t.float :latitude, limit: 53
      t.boolean :needs_recoding

      t.timestamps
    end

    add_index :points, [:longitude, :latitude], unique: true
  end
end