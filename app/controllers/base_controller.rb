class BaseController < ApplicationController
  respond_to :html, :js, :json
  attr_accessor :resource, :collection
  helper_method :resource, :collection

  def self.using_service service_class
    define_method(:service) { service_class }
  end

  def index
    self.collection = service.get_page(params[:page])
    respond_with(collection)
  end

  def show
    self.resource = finder
    respond_with(resource)
  end

  def edit
    self.resource = finder
    respond_with(resource)
  end

  def create
    self.resource = service.new(safe_params)
    resource.save
    respond_with(resource)
  end

  def update
    self.resource = finder
    resource.update_attributes(safe_params)
    respond_with(resource)
  end

  private

  def finder
    service.find(params[:id])
  end

  def safe_params
    raise NotImplementedError, 'Subclasses of BaseController need to define #safe_params!'
  end
end
