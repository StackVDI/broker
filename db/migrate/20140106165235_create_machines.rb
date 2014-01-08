class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.references :image, index: true
      t.references :user, index: true
      t.string :remote_username
      t.string :remote_password
      t.string :remote_address
      t.string :remote_port

      t.timestamps
    end
  end
end
