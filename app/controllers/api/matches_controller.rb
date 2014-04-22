class Api::MatchesController < MatchesController
  api :POST, 'matches.json'
  def create
    super
  end

  api :GET, 'matches.json'
  def index
    super
  end
end
