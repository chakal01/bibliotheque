class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.text :nom

      t.timestamps
    end
  end
end
