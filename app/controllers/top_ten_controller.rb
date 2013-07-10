class TopTenController < ApplicationController
  def show
    spread_singles = MatchPoint.rankings(:spread).first(10)
    bet_singles = MatchPoint.rankings(:bet).first(10)
    @singles = spread_singles.zip(bet_singles)
    spread_doubles = MatchPoint.doubles_rankings(:spread).first(10)
    bet_doubles = MatchPoint.doubles_rankings(:bet).first(10)
    @doubles = spread_doubles.zip(bet_doubles)
  end
end
