class TeamMaker
  class << self
    def team_from(params)
      team = Team.where('name is not NULL').where(name: params[:name].presence.try(:downcase)).first
      unless team
        player1 = Player.where(name: params[:player1][:name].downcase).first || Player.new(name: params[:player1][:name])
        player2 = Player.where(name: params[:player2][:name].downcase).first || Player.new(name: params[:player2][:name])
        team ||= Team.where(
          player1_id: player1,
          player2_id: player2
        ).first
        team ||= Team.new(player1: player1, player2: player2)
        team.name = params[:name]
      end
      team
    end
  end
end
