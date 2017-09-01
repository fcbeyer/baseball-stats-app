class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :firstName
      t.string :lastName
      t.string :playerID
      t.date :birthYear

      t.timestamps
    end
  end
end
