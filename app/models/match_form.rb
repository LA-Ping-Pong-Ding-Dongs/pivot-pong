class MatchForm
  extend  ActiveModel::Naming
  include ActiveModel::Conversion

  def initialize(
      params, 
      player_finder = PlayerFinder.new,
      match_creator = MatchCreator.new
  )
    @params = params
    @player_finder = player_finder
    @match_creator = match_creator
  end
  
  def save
    winner = @player_finder.find_or_create_by_name(@params[:winner])
    loser = @player_finder.find_or_create_by_name(@params[:loser])
    @match_creator.create_match(winner_key: winner.key, loser_key: loser.key)
  end

  def as_json
    @params
  end

  def winner
    @params[:winner]
  end

  def loser
    @params[:loser]
  end

end