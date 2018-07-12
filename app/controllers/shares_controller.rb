class SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_share_quantity, only: [:edit, :update]

  def show
    @user = current_user
    @share = Share.first
  end

  def new
#only admin can set share
    authorize Share
    @share = Share.new
  end

  def create
#only admin can set share 
    authorize Share
    @share = Share.new unless @share = Share.first
    @share.assign_attributes(setting_params)
    if @share.valid?
      @share.save
      flash[:notice] = "Successfully set the share!"
      redirect_to shareshow_path
    else
      flash[:alert] = "Invalid request!"
      redirect_to sharesetting_path
    end
  end

  def edit
#only for quantity > 0, share exists
    @user = current_user
    @share = Share.first
  end

  def update
#only for logged in user, quantity > 0, share exists
    @user = current_user
    @share = Share.first
    requested_quantity = params[:share_trade][:quantity].to_i
    share_params = {}
    user_params = {}
    
    if params[:share_trade][:trade_mode] == 'sell'
      share_params[:quantity] = @share.quantity + requested_quantity
      user_params[:share_quantity] = @user.share_quantity-requested_quantity
      user_params[:money] = @user.money + requested_quantity * @share.sell_price
      @share.assign_attributes(share_params)
      @user.assign_attributes(user_params)
      if @share.valid? && @user.valid?
        @share.save
        @user.save
        flash[:notice] = "Successfully completed"
        redirect_to shareshow_path
      else
        flash[:alert] = "Invalid request!"
        redirect_to sharetrade_path
      end
    else
      share_params[:quantity] = @share.quantity - requested_quantity
      user_params[:share_quantity] = @user.share_quantity + requested_quantity
      user_params[:money] = @user.money - requested_quantity * @share.buy_price
      @share.assign_attributes(share_params)
      @user.assign_attributes(user_params)
      if @share.valid? && @user.valid?
        @share.save
        @user.save
        flash[:notice] = "Successfully complete"
        redirect_to shareshow_path
      else
        flash[:alert] = "Invalid request!"
        redirect_to sharetrade_path
      end
    end
  end

  private
    
    def setting_params
      params.require(:setting).permit(:sell_price, :buy_price, :quantity)
    end
  
    def check_share_quantity
      unless Share.first && Share.first.quantity > 0
        flash[:alert] = "There is no share on the market!"
        redirect_to shareshow_path
      end
    end
end
