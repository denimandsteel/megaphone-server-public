require 'gcm'

class PaymentsController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_action :only_managers, only: [:report]
  
  def report
    query = {}
    
    if params[:vendor]
      query[:vendor_id] = params[:vendor]
    end

    if params[:start] && params[:end]
      start_date = Date.parse(params[:start]).beginning_of_day
      end_date = Date.parse(params[:end]).end_of_day
    else 
      start_date = Date.today.beginning_of_day
      end_date = Date.yesterday.end_of_day
    end

    query[:created_at] = start_date..end_date
    
    @payments = Payment.where(query)

    respond_to do |format|
      format.html { @payments = @payments.order(sort_column + " " + sort_direction).page(params[:page]).per(100) }
      format.csv do
        send_data @payments.to_csv
      end
      format.json do
        return render json: @payments
      end
    end
  end

  def sort_column
    Payment.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end  

end
