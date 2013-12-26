class ImagesRoles < ActiveRecord::Migration
  def change
    create_table(:images_roles, :id => false) do |t|
      t.references :image
      t.references :role
    end

    add_index(:images_roles, [ :image_id, :role_id ])
    
  end
end
