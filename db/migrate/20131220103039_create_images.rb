class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.string :description
      t.references :cloud_server, index: true
      t.string :machine
      t.string :flavor
      t.integer :number_of_instances

      t.timestamps
    end
  end
end
