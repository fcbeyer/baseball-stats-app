json.extract! batting, :id, :playerID, :yearID, :league, :teamID, :gamesPlayed, :hits, :doubles, :triples, :homeruns, :runsBattedIn, :stolenBases, :caughtStealing, :created_at, :updated_at
json.url batting_url(batting, format: :json)
