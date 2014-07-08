class AddConectionPreferencesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :resolution, :string, :default => "fullscreen"
    add_column :users, :gatewayenabled, :boolean, :default => false
    add_column :users, :gatewayhost, :string
    add_column :users, :gatewayuser, :string
    add_column :users, :gatewaypassword, :string
    add_column :users, :speed, :string, :default => "normal"
    add_column :users, :folder, :string
    add_column :users, :showonlaunch, :boolean, :default => false
  end
end
