class AddCouvertureToLivres < ActiveRecord::Migration
  def change
    add_column :livres, :couverture, :text
  end
end
