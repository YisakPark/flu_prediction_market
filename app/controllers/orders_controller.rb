class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_param_validity, only: [:create]

  def create
     OrderProcessJob.perform_later @order
     flash[:success] = "Order is succesfully sent to server."
     redirect_to request.referrer and return
  end

  def get_cost
     render 'securities/get_cost'
  end


  private

    #check whether parameters are valid and save parameters
    def check_param_validity
      @order = current_user.orders.new(setting_params)
      unless @order.valid?
        flash[:danger] = "Invalid request!"
        redirect_to request.referrer and return
      end
      @order.save
      #check whether the buyer user can afford to pay the cost
      if @order.order_type == "buy" &&  @order.cost > current_user.money
        flash[:danger] = "Invalid request!"
        redirect_to request.referrer and return
      end
      #check whether the seller user has enough share quantity to sell
      if @order.order_type == "sell" && not(@order.does_user_has_enough_shares?)
        flash[:danger] = "Invalid request!"
        redirect_to request.referrer and return
      end
    end

    #set parameters to make new order object
    def setting_params
      params_arr = {}
      params_arr = params.require(:security_order).permit(:order_type, :quantity)
      security_ids = []
      #get number of security to process
      number_of_security_to_process = 0
      if params_arr[:order_type] == "buy"
        number_of_security_to_process = params.require(:security_order).permit(:number_of_security_to_buy)[:number_of_security_to_buy]
      elsif params_arr[:order_type] == "sell"
        number_of_security_to_process = params.require(:security_order).permit(:number_of_security_to_sell)[:number_of_security_to_sell]
      end
      #make array of securities to be ordered
      number_of_security_to_process.to_i.times do |x|
        hash = "order_id_#{x+1}"
        security_ids.push params.require(:security_order).permit(hash.to_sym)[hash.to_sym]
      end
      params_arr[:security_ids] = security_ids
      params_arr
    end

end

