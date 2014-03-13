class TournamentController < ApplicationController

  def show
    standings = tournament.determine_rankings
    render json: { results: standings.map{ |standing| PlayerStandingJsonPresenter.new(standing).as_json } }.as_json
  end

  private

  def tournament
    Tournament.new
  end

end
