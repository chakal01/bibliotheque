class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.text :nom

      t.timestamps
    end
  end
end
