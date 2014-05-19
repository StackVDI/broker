class AddMachineLifetimeToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :machine_lifetime, :integer, :default => 24
    add_column :roles, :machine_idletime, :integer, :default => 24
  end
end
