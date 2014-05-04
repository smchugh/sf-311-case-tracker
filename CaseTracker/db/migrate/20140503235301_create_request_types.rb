class CreateRequestTypes < ActiveRecord::Migration
  def change
    create_table :request_types do |t|
      t.string :name

      t.timestamps
    end

    add_index :request_types, :name, :unique => true
  end
end
