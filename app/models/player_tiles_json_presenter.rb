class PlayerTilesJsonPresenter
  include Rails.application.routes.url_helpers

  def initialize(players)
    @players = players
  end

  def as_json(options = {})
    @players.map do |player|
      {
          name: player.name,
          url: "#/players/#{player.key}",
          mean: player.mean,
          key: player.key,
      }
    end
  end

end
