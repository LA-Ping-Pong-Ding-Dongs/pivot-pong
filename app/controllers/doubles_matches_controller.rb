class DoublesMatchesController < ApplicationController
  def index
    @match = Match.new(winner: Team.new, loser: Team.new)
    @matches = Match.doubles_matches
  end

  def rankings
    @rankings = MatchPoint.doubles_rankings
    render 'matches/rankings'
  end

  def create
    winner_player_1 = Player.find_or_create_by_name(params[:match][:winner][:player1][:name].downcase)
    winner_player_2 = Player.find_or_create_by_name(params[:match][:winner][:player2][:name].downcase)

    loser_player_1 = Player.find_or_create_by_name(params[:match][:loser][:player1][:name].downcase)
    loser_player_2 = Player.find_or_create_by_name(params[:match][:loser][:player2][:name].downcase)

    winner = Team.find_or_create_by_player1_id_and_player2_id winner_player_1.id, winner_player_2.id
    loser  = Team.find_or_create_by_player1_id_and_player2_id loser_player_1.id, loser_player_2.id

    match = Match.new winner: winner, loser: loser

    unless [winner, loser].all?(&:valid?) && match.save
      flash.alert = "Must specify a winner and a loser to post a match."
      render :action => 'index'
    else
      redirect_to doubles_matches_path
    end

  end
end

