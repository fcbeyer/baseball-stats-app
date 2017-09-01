json.extract! player, :id, :firstName, :lastName, :playerID, :birthYear, :created_at, :updated_at
json.url player_url(player, format: :json)
