class LocationsController < ApplicationController

  helper_method :sort_column, :sort_direction
  
  before_action :only_admin, except: [:index]
  before_action :only_managers, only: [:new, :edit]
  
  def index
    # @locations = Location.all
    @locations = Location.includes(:vendor).all
    @locations = @locations.where('city = ?', params[:city]) if params[:city].present?
    @locations = @locations.where('neighbourhood = ?', params[:neighbourhood]) if params[:neighbourhood].present?
    
    # reject locations that don't have valid vendor ids
    @locations = @locations.reject { |location| !location.vendor.present? }

    respond_to do |format|
      format.html
      format.json { render :json => @locations.to_json(include: [:vendor]) }
    end
  end
end
