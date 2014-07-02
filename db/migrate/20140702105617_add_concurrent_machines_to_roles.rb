class AddConcurrentMachinesToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :concurrent_machines, :integer, :default => '1'
  end
end
