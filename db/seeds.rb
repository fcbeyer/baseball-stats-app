# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

csv_players = File.read(Rails.root.join('lib', 'seeds', 'players.csv'))
players_parsed = CSV.parse(csv_players, :headers => true, :encoding => 'ISO-8859-1')
players_parsed.each do |row|
  player = Player.new
  player.firstName = row['nameFirst']
  player.lastName = row['nameLast']
  player.birthYear = row['birthYear']
  player.playerID = row['playerID']
  player.save
  #puts "#{player.firstName}, #{player.lastName} saved"
end

puts "There are now #{Player.count} rows in the players table"



csv_batting = File.read(Rails.root.join('lib', 'seeds', 'batting.csv'))
batting_parsed = CSV.parse(csv_batting, :headers => true, :encoding => 'ISO-8859-1')
batting_parsed.each do |row|
  {"playerID"=>"zumayjo01", "yearID"=>"2007", "league"=>"AL", "teamID"=>"DET", "G"=>"28", "AB"=>nil, "R"=>nil, "H"=>nil, "2B"=>nil, "3B"=>nil, "HR"=>nil, "RBI"=>nil, "SB"=>nil, "CS"=>nil}
  player = Player.find_by(playerID: row['playerID'])
  player.battings.create(playerID: row['playerID'], yearID: row['yearID'], league: row['league'], teamID: row['teamID'],
    gamesPlayed: row['G'], atBats: row['AB'], runs: row['R'], hits: row['H'], doubles: row['2B'], triples: row['3B'],
    homeruns: row['HR'], runsBattedIn: row['RBI'], stolenBases: row['SB'], caughtStealing: row['CS']);
end

puts "There are now #{Batting.count} rows in the battings table"