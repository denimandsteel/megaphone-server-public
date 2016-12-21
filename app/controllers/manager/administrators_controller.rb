class Manager::AdministratorsController < ApplicationController
  
  helper_method :sort_column, :sort_direction

  before_action :load_administrator, only: [:edit, :update, :destroy]
  before_action :only_managers, except: :dashboard
  before_action :only_admin, only: :dashboard

  def dashboard
    @in_app_products = Product.order('products.order ASC').available_in_app
    @vendors_awaiting_payments = Vendor.has_unpaid_purchases
  end

  def index
    @administrators = Administrator.all
    @administrators = @administrators.order(sort_column + " " + sort_direction)
  end

  def new
    @administrator = Administrator.new
  end

  def edit
    @administrator.full_name = @administrator.full_name.titleize
  end

  def create
    @administrator = Administrator.new(administrator_params)
    @administrator.created_by = current_administrator
  
    if @administrator.save
      redirect_to manager_administrators_path, notice: 'Administrator was successfully created.'
    else
      render :new 
    end
  end

  def update
    @administrator.update_attributes(administrator_params)

    if @administrator.save
      redirect_to manager_administrators_path, notice: 'Administrator was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @administrator.destroy
      redirect_to manager_administrators_path, notice: 'Administrator was successfully destroyed.'
    else
      render :edit
    end
  end

  private

  def load_administrator
    @administrator = Administrator.find(params[:id])
  end

  def administrator_params
    if params[:administrator][:password].present? && params[:administrator][:password_confirmation].present?
      params.require(:administrator).permit(
        :full_name,
        :manager,
        :password,
        :password_confirmation
      )
    else
      params.require(:administrator).permit(
        :full_name,
        :manager
        )    
    end  
  end

  def sort_column
    Administrator.column_names.include?(params[:sort]) ? params[:sort] : "full_name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end  
end
