module BaseService
  def get_page(page)
    decorate_collection(paged(collection_source, page: page))
  end

  def get_all
    decorate_collection(collection_source)
  end

  def find id
    decorate(collection_source.find(id))
  end

  # redefine in your own service class to change
  def page_size
    10
  end

  def paged(collection_object, page:)
    collection_object.page(page).per(page_size)
  end

  def decorate_collection(collection_object)
    if decorator
      PaginatingDecorator.decorate(collection_object, with: decorator)
    else
      collection_object
    end
  end

  def decorate(instance)
    if decorator
      decorator.decorate(instance)
    else
      instance
    end
  end

  def decorator
    nil
  end

end
