module PlayerService
  extend self, BaseService

  def collection_source; Player.all; end
end
