module PlayerService
  extend self, BaseService

  def collection_source; Player.all; end
  def decorator; PlayerDecorator; end

  def find identifier
    decorate(collection_source.find_by key: identifier)
  end
end
