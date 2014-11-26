class AddPagesAndDescriptionToLivres < ActiveRecord::Migration
  def change
    add_column :livres, :nb_pages, :integer
    add_column :livres, :description, :text 
  end
end
