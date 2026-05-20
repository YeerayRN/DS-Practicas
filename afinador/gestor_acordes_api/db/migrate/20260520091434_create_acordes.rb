class CreateAcordes < ActiveRecord::Migration[8.1]
  def change
    create_table :acordes do |t|
      t.string :nombre
      t.integer :cuerda1
      t.integer :cuerda2
      t.integer :cuerda3
      t.integer :cuerda4
      t.integer :cuerda5
      t.integer :cuerda6

      t.timestamps
    end
  end
end
