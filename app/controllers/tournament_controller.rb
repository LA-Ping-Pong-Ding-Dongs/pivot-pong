class TournamentController < ApplicationController

  def show
    @standings = tournament_ranking.determine_rankings

    respond_to do |format|
      format.js { render json: { results: @standings.map{ |standing| PlayerStandingJsonPresenter.new(standing).as_json } }.as_json }
      format.html
    end
  end

  private

  def tournament_ranking
    TournamentRanking.new
  end

end
