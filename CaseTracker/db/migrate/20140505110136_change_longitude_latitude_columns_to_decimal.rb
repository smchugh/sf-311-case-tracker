class ChangeLongitudeLatitudeColumnsToDecimal < ActiveRecord::Migration
  def change
    change_column :points, :latitude, :decimal, precision: 18, scale: 14
    change_column :points, :longitude, :decimal, precision: 18, scale: 14
  end
end
