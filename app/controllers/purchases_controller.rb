require 'gcm'

class PurchasesController < ApplicationController
  helper_method :sort_column, :sort_direction, :purchased_products_ids, :purchased_products_titles

  before_action :identify_device_token, only: [:create, :index, :show]
  before_action :only_managers, only: [:update, :report]
  before_action :load_purchase, only: [:show] 

  def index
    respond_to do |format|
      format.json do
        return render json: @device.purchases
      end
    end
  end

  def report
    @purchases = Purchase.all
    @setting = Setting.find_or_create_by(setting_name: "Purchases Last Downloaded At")
    @downloaded_on = DateTime.strptime(@setting.setting_value) if @setting.setting_value.present?

    @setting_email = Setting.find_or_create_by(setting_name: "Daily Report Email Address")
    @setting_send_daily = Setting.find_or_create_by(setting_name: "Daily Report Send")

    @email = @setting_email.setting_value if @setting_email.setting_value.present?
    @send_daily = (@setting_send_daily.setting_value == "true") if @setting_send_daily.setting_value.present?

    @setting_email.save
    @setting_send_daily.save

    respond_to do |format|
      format.html { @purchases = @purchases.order(sort_column + " " + sort_direction).page(params[:page]).per(100) }
      format.csv do
        @setting.update_attribute(:setting_value, DateTime.now)
        send_data @purchases.to_csv
      end
      format.json do
        return render json: @purchases
      end
    end
  end

  def report_settings
    puts 'report_settings called!';
    puts params.inspect
    @setting_email = Setting.find_or_create_by(setting_name: "Daily Report Email Address")
    @setting_send_daily = Setting.find_or_create_by(setting_name: "Daily Report Send")

    if params.has_key?(:email)
      @setting_email.update_attribute(:setting_value, params[:email])
    end

    if params.has_key?(:send_daily)
      @setting_send_daily.update_attribute(:setting_value, 'true')
    else
      @setting_send_daily.update_attribute(:setting_value, 'false')
    end

    @setting_email.save
    @setting_send_daily.save

    redirect_to :back, flash: {success: true}
  end

  def create
    # Will need to confirm device api_token before creating a purchase
    respond_to do |format|
      format.json do
        @purchase = @device.purchases.build(purchase_params)
        @purchase.transaction_id = SecureRandom.hex(2).upcase

        if @purchase.tips.nil?
          @purchase.tips = 0
        # else
        #   @purchase.tips = @purchase.tips * 100
        end

        @purchase.products_amount = @purchase.product_total

        if @purchase.payment_method == "creditcard"
          # Will use the device stripe_customer to complete the transaction
          begin
            charge = Stripe::Charge.create(
              :customer    => @device.stripe_customer,
              :amount      => @purchase.chargeable_amount,
              :description => "Purchase #{@purchase.transaction_id} for #{@purchase.vendor.name} (#{@purchase.vendor.badge_id})",
              :currency    => ENV['STRIPE_CURRENCY']
            )
          rescue => e
            return render json: e.message, status: e.http_status
          end
        elsif @purchase.payment_method == "applepay"
          # Will use the device apple_pay_token to complete the transaction
          begin
            charge = Stripe::Charge.create(
              :source      => @device.apple_pay_token,
              :amount      => @purchase.chargeable_amount,
              :description => "Purchase #{@purchase.transaction_id} for #{@purchase.vendor.name} (#{@purchase.vendor.badge_id})",
              :currency    => ENV['STRIPE_CURRENCY']
            )
          rescue => e
            puts e.inspect
            return render json: e.message, status: e.http_status
          end
        else
          puts "Unknown payment type: #{@purchase.payment_method}"
        end

        @purchase.payment_id = charge.id

        if @purchase.save
          product_ids = @purchase.products.map(&:id)

          product_ids_count = Hash.new(0)
          product_ids.each do |id|
            product_ids_count[id] += 1
          end

          @purchase.purchase_products.each do |purchase_product|
            purchase_product.quantity = product_ids_count[purchase_product.product_id]
            purchase_product.save
          end

          render json: @purchase
        else
          render json: @purchase.errors.full_messages, status: 400
        end
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render :json => @purchase.to_json(include: [:vendor, :products]) }
    end
  end

  def update
    @vendor = Vendor.find(params[:id])
    @unpaid_purchases = @vendor.unpaid_purchases
    @unpaid_purchases.each do |purchase|
      purchase.update_attributes({
        paid_by: current_administrator,
        paid: true,
        paid_at: DateTime.now
      })
    end

    @payment = @vendor.payments.build({
      paid_by: current_administrator,
      amount: @unpaid_purchases.map { |purchase| purchase.total_amount }.sum
    })

    if @payment.save
      redirect_to vendor_path(@vendor), notice: "#{@vendor.name} was successfully paid out!"

      # PUSH NOTIFICATIONS
      gcm = GCM.new(ENV['GCM_API_KEY'])
      sent_pairs = []
      @unpaid_purchases.each do |purchase|
        vendor_token_pair = {token: purchase.device.push_notification_token, vendor: purchase.vendor.id}
        unless sent_pairs.include?(vendor_token_pair)
          sent_pairs.push(vendor_token_pair)
          registration_ids = [purchase.device.push_notification_token]
          options = { 
            notification: { 
              title: "Street Sense Vendor Payments",
              body: "#{purchase.vendor.name} just received the money from your purchase. Thank you!",
              badge: 0,
              sound: "default" 
            },
            priority: 'high'
          }
          response = gcm.send(registration_ids, options)
          puts 'GCM response:'
          puts response
        end    
      end
    else
      redirect_to review_payment_vendor_path(@vendor)
    end
  end

  protected

  def purchase_params
    params.require(:purchase).permit(
      :transaction_id,
      :vendor_id,
      :products_amount,
      :payment_id,
      :payment_method,
      :tips,
      :product_ids => []
    )
  end

  def load_purchase
    @purchase = Purchase.find(params[:id])
  end

  def sort_column
    Purchase.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end  

end
