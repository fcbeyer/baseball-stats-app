class CreateBattings < ActiveRecord::Migration[5.1]
  def change
    create_table :battings do |t|
      t.string :playerID
      t.date :yearID
      t.string :league
      t.string :teamID
      t.integer :gamesPlayed
      t.integer :atBats
      t.integer :runs
      t.integer :hits
      t.integer :doubles
      t.integer :triples
      t.integer :homeruns
      t.integer :runsBattedIn
      t.integer :stolenBases
      t.integer :caughtStealing
      t.integer :player_id

      t.timestamps
    end
  end
end
