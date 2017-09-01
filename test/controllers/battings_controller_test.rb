require 'test_helper'

class BattingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @batting = battings(:one)
  end

  test "should get index" do
    get battings_url
    assert_response :success
  end

  test "should get new" do
    get new_batting_url
    assert_response :success
  end

  test "should create batting" do
    assert_difference('Batting.count') do
      post battings_url, params: { batting: { caughtStealing: @batting.caughtStealing, doubles: @batting.doubles, gamesPlayed: @batting.gamesPlayed, hits: @batting.hits, homeruns: @batting.homeruns, league: @batting.league, playerID: @batting.playerID, runsBattedIn: @batting.runsBattedIn, stolenBases: @batting.stolenBases, teamID: @batting.teamID, triples: @batting.triples, yearID: @batting.yearID } }
    end

    assert_redirected_to batting_url(Batting.last)
  end

  test "should show batting" do
    get batting_url(@batting)
    assert_response :success
  end

  test "should get edit" do
    get edit_batting_url(@batting)
    assert_response :success
  end

  test "should update batting" do
    patch batting_url(@batting), params: { batting: { caughtStealing: @batting.caughtStealing, doubles: @batting.doubles, gamesPlayed: @batting.gamesPlayed, hits: @batting.hits, homeruns: @batting.homeruns, league: @batting.league, playerID: @batting.playerID, runsBattedIn: @batting.runsBattedIn, stolenBases: @batting.stolenBases, teamID: @batting.teamID, triples: @batting.triples, yearID: @batting.yearID } }
    assert_redirected_to batting_url(@batting)
  end

  test "should destroy batting" do
    assert_difference('Batting.count', -1) do
      delete batting_url(@batting)
    end

    assert_redirected_to battings_url
  end
end
