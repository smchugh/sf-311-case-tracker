class CreateResponsibleAgencies < ActiveRecord::Migration
  def change
    create_table :responsible_agencies do |t|
      t.string :name

      t.timestamps
    end

    add_index :responsible_agencies, :name, :unique => true
  end
end
