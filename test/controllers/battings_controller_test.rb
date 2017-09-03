require 'test_helper'

class BattingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @batting = battings(:one)
    @player = Batting.first
  end

  test "should get index" do
    get player_battings_url(@player), params: { player_id: @player.id }
    assert_response :success
  end

  test "should get new" do
    get new_player_batting_url(@player), params: { player_id: @player.id }
    assert_response :success
  end

  test "should create batting" do
    assert_difference('Batting.count') do
      post player_battings_url, params: { batting: { caughtStealing: @batting.caughtStealing, doubles: @batting.doubles, gamesPlayed: @batting.gamesPlayed, hits: @batting.hits, homeruns: @batting.homeruns, league: @batting.league, playerID: @batting.playerID, runsBattedIn: @batting.runsBattedIn, stolenBases: @batting.stolenBases, teamID: @batting.teamID, triples: @batting.triples, yearID: @batting.yearID } }
    end

    assert_redirected_to batting_url(Batting.last)
  end

  test "should show batting" do
    get player_batting_url(@batting)
    assert_response :success
  end

  test "should get edit" do
    get edit_player_batting_url(@batting)
    assert_response :success
  end

  test "should update batting" do
    patch player_batting_url(@batting), params: { batting: { caughtStealing: @batting.caughtStealing, doubles: @batting.doubles, gamesPlayed: @batting.gamesPlayed, hits: @batting.hits, homeruns: @batting.homeruns, league: @batting.league, playerID: @batting.playerID, runsBattedIn: @batting.runsBattedIn, stolenBases: @batting.stolenBases, teamID: @batting.teamID, triples: @batting.triples, yearID: @batting.yearID } }
    assert_redirected_to batting_url(@batting)
  end

  test "should destroy batting" do
    assert_difference('Batting.count', -1) do
      delete player_batting_url(@batting)
    end

    assert_redirected_to player_battings_url
  end
end
