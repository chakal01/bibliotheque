class ChangeAchatFormat < ActiveRecord::Migration
  def up
    change_column :livres, :achat, :text
  end

  def down
    rename_column :livres, :achat, :achat_temp
    add_column :livres, :achat, :integer
    Livre.find_each do |livre|
      livre.achat = livre.achat_temp.to_i
      livre.save
    end
    remove_column :livres, :achat_temp
  end
end
