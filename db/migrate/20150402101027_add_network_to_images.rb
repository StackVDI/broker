class AddNetworkToImages < ActiveRecord::Migration
  def change
    add_column :images, :network, :string
  end
end
