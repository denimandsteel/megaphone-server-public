require 'gcm'

class ProductsController < ApplicationController

  before_action do |controller|
    controller.send(:only_managers) unless controller.request.format.json?
  end

  before_action :load_product, except: [:index, :new, :create]

  def index
    @products = Product.order('products.order ASC').all
    respond_to do |format|
      format.html
      format.json { render :json => @products.available_in_app.to_json }
    end
  end

  def new
    @product = Product.new
  end

  def create
    the_params = product_params
    the_params[:price] = the_params[:price_in_dollars].to_f * 100.0
    the_params.delete :price_in_dollars
    @product = Product.new(the_params)
    
    if @product.save
      redirect_to products_path
    else
      render :new
    end
  end

  def update
    the_params = product_params
    the_params[:price] = the_params[:price_in_dollars].to_f * 100.0 unless the_params[:price_in_dollars].nil?
    the_params.delete :price_in_dollars
    @product.assign_attributes(the_params)
    
    if params[:notify_update]
      @product.last_notification_date = DateTime.now
    end

    if @product.save
      # Push Notification
      if params[:notify_update]
        gcm = GCM.new(ENV['GCM_API_KEY'])
        eligible_devices = Device.where("push_notification_token is NOT NULL and push_notification_token != ''")
        registration_ids = eligible_devices.map {|device| device.push_notification_token}.uniq
        
        options = { 
          notification: { 
            title: "Megaphone Vendor Finder",
            body: "New #{@product.title} now available!",
            badge: 0,
            sound: "default" 
          },
          priority: 'high'
        }
        response = gcm.send(registration_ids, options)
        puts 'GCM response:'
        puts response
      end

      respond_to do |format|
        format.html { redirect_to products_path }
        format.json { render :json => @product.to_json }
      end
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      redirect_to products_path
    else
      render :new
    end
  end

  protected

  def product_params
    params.require(:product).permit(
      :title,
      :description,
      :price,
      :price_in_dollars,
      :image,
      :in_app,
      :category,
      :order
    )
  end

  def load_product
    @product = Product.find(params[:id])
  end  

end
