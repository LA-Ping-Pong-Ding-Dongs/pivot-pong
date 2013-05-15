class DoublesMatchesController < ApplicationController
  def index
    @matches = Match.doubles_matches
  end

  def rankings
    @rankings = MatchPoint.doubles_rankings
    render 'matches/rankings'
  end
end

