class AddUsuarioToAcordes < ActiveRecord::Migration[8.1]
  def change
    add_reference :acordes, :usuario, null: false, foreign_key: true
  end
end
