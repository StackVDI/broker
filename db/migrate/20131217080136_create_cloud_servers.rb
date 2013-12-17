class CreateCloudServers < ActiveRecord::Migration
  def change
    create_table :cloud_servers do |t|
      t.string :name
      t.string :description
      t.string :username
      t.string :password
      t.string :url

      t.timestamps
    end
  end
end
