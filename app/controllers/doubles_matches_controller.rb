class DoublesMatchesController < ApplicationController
  before_filter :set_doubles_matches, only: [:index, :create]

  def index
    @match = Match.new(winner: Team.new, loser: Team.new)
  end

  def rankings
    @rankings = MatchPoint.doubles_rankings
    render 'matches/rankings'
  end

  def create
    teams = params[:match]
    winner = TeamMaker.team_from(teams[:winner])
    loser  = TeamMaker.team_from(teams[:loser])

    @match = Match.new winner: winner, loser: loser

    if [winner, loser].all?(&:valid?) && @match.save
      redirect_to doubles_matches_path
    else
      render :action => 'index', alert: 'Must specify a winner and a loser to post a match.'
    end
  end

  private
  def set_doubles_matches
    @matches = Match.doubles_matches
  end
end

