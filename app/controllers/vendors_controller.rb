class VendorsController < ApplicationController

  helper_method :sort_column, :sort_direction
  
  before_action :only_admin, except: [:index, :show]
  before_action :only_managers, only: [:new, :edit]
  before_action :load_vendor, except: [:new, :create, :index]
  before_action :load_products, only: [:new, :edit, :create] 

  def index
    if params[:city]
      @locations = Location.includes(vendor: [:products, :locations]).where('city = ?', params[:city]);
      @vendors = @locations.map {|location| location.vendor}.uniq.reject { |vendor| !vendor }.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    elsif params[:neighbourhood]
      @locations = Location.includes(vendor: [:products, :locations]).where('neighbourhood = ?', params[:neighbourhood]);
      @vendors = @locations.map {|location| location.vendor}.uniq.reject { |vendor| !vendor }.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    else
      @vendors = Vendor.includes(:locations, :products).all
      @vendors = @vendors.limit(25).order(sort_column + " " + sort_direction)
    end
    respond_to do |format|
      format.html
      format.json { render :json => @vendors.reject {|vendor| !vendor.in_app }.to_json(include: [:locations, :products]) }
    end
  end

  def show
    @last_payment = @vendor.payments.last
    respond_to do |format|
      format.html
      format.json { render :json => @vendor.to_json(include: [:locations, :products]) }
    end
  end

  def new
    @vendor = Vendor.new
    @vendor.locations.build
  end

  def create
    @vendor = Vendor.new(vendor_params)

    if @vendor.save
      redirect_to vendors_path
    else
      render :new
    end
  end

  def edit
    @vendor.locations.build
  end

  def update
    @vendor.update_attributes(vendor_params)
    @vendor.updated_by = current_administrator

    if @vendor.save
      redirect_to vendor_path(@vendor)
    else
      render :edit
    end
  end

  def destroy
    if @vendor.destroy
      redirect_to vendors_path
    else
      render :edit
    end
  end

  def review_payment
    @unpaid_purchases = @vendor.unpaid_purchases
  end

  protected

  def vendor_params
    params.require(:vendor).permit(
      :name,
      :badge_id,
      :image,
      :in_app,
      :has_back_issues,
      :locations_attributes => [:id, :name, :city, :neighbourhood, :cross_street, :hours, :description, :_destroy],
      :product_ids => []
    )
  end

  def load_vendor
    @vendor = Vendor.find(params[:id])
  end

  def load_products
    @products = Product.all
  end

  def sort_column
    Vendor.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end  

end
