class DevicesController < ApplicationController

  before_action :identify_device_token, except: [:create]

  def index
    render json: [@device]
  end

  def show
    render json: @device
  end

  def create
    respond_to do |format|
      format.json {
        @device = Device.new
        @device.api_token = SecureRandom.uuid

        # TODO: this may not be necessary, 
        #       there's no credit card info when a device instance is created in the app
        if params.has_key?(:card_number)
          begin
            card = Stripe::Token.create(
              card: {
                number: params[:card_number], # "4242424242424242"
                exp_month: params[:card_expiry_month].to_i, # 11, 'to_i is only for Postman testing' 
                exp_year: params[:card_expiry_year].to_i, # 2016, 'to_i is only for Postman testing'
                cvc: params[:card_cvc] # "314"
              }
            )
            
            @device.last_four_digits = card.card.last4

            customer = Stripe::Customer.create(
              source: card,
              description: "Megaphone Customer"
            )
          rescue Stripe::CardError => e
            return render json: "Stripe: #{e.message}", status: 400
          end

          @device.stripe_customer = customer.id
        end

        if params.has_key?(:enable_location)
          @device.enable_location = params[:enable_location]
        end

        if params.has_key?(:enable_notifications)
          @device.enable_notifications = params[:enable_notifications]
        end

        if @device.save
          render json: @device
        else
          render json: @device.errors.full_messages, status: 400
        end
      }
    end
  end

  def update
    # TODO: clean this up, remove app versioning here:
    # App version 1.2
    if params.has_key?(:card_number)
      begin
        card = Stripe::Token.create(
          card: {
            number: params[:card_number], 
            exp_month: params[:card_expiry_month].to_i,
            exp_year: params[:card_expiry_year].to_i,
            cvc: params[:card_cvc]
          }
        )

        @device.last_four_digits = card.card.last4
        
        customer = Stripe::Customer.create(
          source: card,
          description: "Megaphone Customer"
        )

        @device.stripe_customer = customer.id

      rescue Stripe::CardError => e
        return render json: "Stripe: #{e.message}", status: 400
      end
    # App version 1.3
    elsif params.has_key?(:stripe_card_token) and params.has_key?(:last_four_digits)
      begin
        # TODO: do we need to make a new customer everytime the card is updated?
        customer = Stripe::Customer.create(
          source: params[:stripe_card_token],
          description: "Megaphone Customer"
        )
        
        @device.last_four_digits = params[:last_four_digits]
        @device.stripe_customer = customer.id
        @device.card_token = params[:stripe_card_token]

      rescue Stripe::CardError => e
        return render json: "Stripe: #{e.message}", status: 400
      rescue Stripe::InvalidRequestError => e
        return render json: "Stripe: #{e.message}", status: 400
      end
    end

    if params.has_key?(:enable_location)
      @device.enable_location = params[:enable_location]
    end

    if params.has_key?(:enable_notifications)
      @device.enable_notifications = params[:enable_notifications]
    end

    if params.has_key?(:push_notification_token)
      @device.push_notification_token = params[:push_notification_token]
    end

    if params.has_key?(:apple_pay_token)
      @device.apple_pay_token = params[:apple_pay_token]
    end

    if @device.save
      render json: @device
    else
      render json: @device.errors.full_messages, status: 400
    end
    
  end

  def recent_vendors
    @device = Device.find(params[:id])
    render json: @device.recent_vendors
  end

  def recent_transactions
    @device = Device.find(params[:id])
    render json: @device.purchases
  end
  
end
