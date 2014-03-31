class TournamentController < ApplicationController

  def show
    standings = tournament.determine_rankings

    respond_to do |format|
      format.js { render json: { results: standings.map{ |standing| PlayerStandingJsonPresenter.new(standing).as_json } }.as_json }
      format.html { render nothing: true }
    end
  end

  private

  def tournament
    Tournament.new
  end

end
