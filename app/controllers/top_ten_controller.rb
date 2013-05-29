class TopTenController < ApplicationController

  def show
    @singles = MatchPoint.rankings.first(10)
    @doubles = MatchPoint.doubles_rankings.first(10)
  end

end
