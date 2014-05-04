class AddClosedColumnToCases < ActiveRecord::Migration
  def change
    add_column :cases, :closed, :datetime
  end
end
