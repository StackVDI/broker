class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string, default: "First Name"
    add_column :users, :last_name, :string, default: "Last Name"
  end
end
