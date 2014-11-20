class ChangeDateFormatInAuteur < ActiveRecord::Migration
  def up
    remove_column :auteurs, :naissance
    remove_column :auteurs, :mort
    add_column :auteurs, :naissance, :integer
    add_column :auteurs, :mort, :integer
  end

  def down
    remove_column :auteurs, :naissance
    remove_column :auteurs, :mort
    add_column :auteurs, :naissance, :datetime
    add_column :auteurs, :mort, :datetime
  end
end
