class BaseController < ApplicationController
  respond_to :html, :js, :json
  attr_accessor :resource, :collection
  helper_method :resource, :collection

  def self.using_service service_class
    define_method(:service) { service_class }
  end

  def index
    self.collection = service.get_page(params[:page])
    respond_to do |format|
      format.json { render json: { results: collection.as_json } }
      format.html { respond_with collection }
    end
  end

  def show
    self.resource = finder
    respond_to do |format|
      format.json { render json: resource }
      format.html { respond_with resource }
    end
  end

  def edit
    self.resource = finder
    respond_to do |format|
      format.html { respond_with resource }
    end
  end

  def create
    self.resource = service.new(safe_params)
    respond_to do |format|
      if resource.save
        format.json { render json: resource, status: 201 }
        format.html { redirect_to root_path }
      else
        format.json { render status: 400, json: resource.as_json.merge(resource.errors.as_json) }
        format.html { redirect_to root_path, alert: resource.error_messages }
      end
    end
  end

  def update
    self.resource = finder
    respond_to do |format|
      if resource.update_attributes(safe_params)
        format.html { redirect_to resource }
      else
        format.html { render action: :edit }
      end
    end
  end

  private

  def finder
    service.find(params[:id])
  end

  def safe_params
    raise NotImplementedError, 'Subclasses of BaseController need to define #safe_params!'
  end
end
