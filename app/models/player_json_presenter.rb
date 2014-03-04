class PlayerJsonPresenter
  include Rails.application.routes.url_helpers

  def initialize(players)
    @players = players
  end

  def as_json(options = {})
    @players.map do |player|
      {
          name: player.name,
          url: player_path(player.key),
          mean: player.mean,
      }
    end
  end

end