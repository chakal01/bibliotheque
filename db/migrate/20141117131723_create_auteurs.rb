class CreateAuteurs < ActiveRecord::Migration
  def change
    create_table :auteurs do |t|
      t.text :nom
      t.text :photo
      t.datetime :naissance
      t.datetime :mort
      t.text :nationalite

      t.timestamps
    end
  end
end
