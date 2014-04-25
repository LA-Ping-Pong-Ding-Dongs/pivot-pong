class PlayersSearchController < BaseController
  using_service PlayerService

  def index
    self.collection = service.find_by_substring(params[:search])
    respond_with collection
  end
end
