module PlayersHelper

  def calculate_career_batting_average(player)
    #total hits (singles, double, triples, home runs) ÷ At Bats
    total_hits = player.battings.map(&:hits).compact.sum
    total_at_bats = player.battings.map(&:atBats).compact.sum
    return total_hits.fdiv(total_at_bats)
  end

  def calculate_career_slugging_percentage(player)
    #Total Bases ÷ At Bats
    #Total Bases = Singles + (2 x Doubles) + (3 x Triples) + (4 x Home Runs)
    total_at_bats = player.battings.map(&:atBats).compact.sum
    total_singles = player.battings.map(&:hits).compact.sum - player.battings.map(&:doubles).compact.sum -
        player.battings.map(&:triples).compact.sum - player.battings.map(&:homeruns).compact.sum
    total_bases = total_singles + (2 * player.battings.map(&:doubles).compact.sum) +
        (3 * player.battings.map(&:triples).compact.sum) + (4 * player.battings.map(&:homeruns).compact.sum)
    return total_bases.fdiv(total_at_bats)
  end

  #need to figure out if how to handle NaN
  def calculate_season_batting_average(batting)
    #total hits (singles, double, triples, home runs) ÷ At Bats
    if batting.hits and batting.atBats then
      ba = batting.hits.fdiv(batting.atBats)
      return ba.nan? ? 'N/A' : number_with_precision(ba)
    end
  end

  def calculate_season_slugging_percentage(batting)
    #Total Bases ÷ At Bats
    #Total Bases = Singles + (2 x Doubles) + (3 x Triples) + (4 x Home Runs)
    if batting.hits and batting.doubles and batting.triples and batting.homeruns and batting.atBats then
      singles = batting.hits - batting.doubles - batting.triples - batting.homeruns
      total_bases = singles + (2 * batting.doubles) + (3 * batting.triples) + (4 * batting.homeruns)
      sg = total_bases.fdiv(batting.atBats)
      return sg.nan? ? 'N/A' : number_with_precision(sg)
    end
  end

end
