class CreateEmplacements < ActiveRecord::Migration
  def change
    create_table :emplacements do |t|
      t.text :nom

      t.timestamps
    end
  end
end
