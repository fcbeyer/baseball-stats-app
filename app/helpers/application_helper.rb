module ApplicationHelper

  def calculate_career_batting_average(player)
    #total hits (singles, double, triples, home runs) ÷ At Bats
    total_hits = player.battings.sum(&:hits)
    total_at_bats = player.battings.sum(&:atBats)
    return total_hits.fdiv(total_at_bats)
  end

  def calculate_career_slugging_percentage(player)
    #Total Bases ÷ At Bats
    #Total Bases = Singles + (2 x Doubles) + (3 x Triples) + (4 x Home Runs)
    total_at_bats = player.battings.sum(&:atBats)
    total_singles = player.battings.sum(&:hits) - player.battings.sum(&:doubles) -
        player.battings.sum(&:triples) - player.battings.sum(&:homeruns)
    total_bases = total_singles + (2 * player.battings.sum(&:doubles)) + (3 * player.battings.sum(&:triples)) +
        (4 * player.battings.sum(&:homeruns))
    return total_bases.fdiv(total_at_bats)
  end
end
