class CreateLivres < ActiveRecord::Migration
  def change
    create_table :livres do |t|
      t.text :titre
      t.references :auteur, index: true
      t.references :edition, index: true
      t.references :genre, index: true
      t.references :emplacement, index: true
      t.integer :parution
      t.integer :achat
      t.timestamps
    end
  end
end
