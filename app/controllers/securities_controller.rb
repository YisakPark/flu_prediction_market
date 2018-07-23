class SecuritiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_money = current_user.money
    @user_securities = LineShare.where(user_id: current_user.id, available: true)
    @security
  end

  def show
    @building = params[:building]
    #if there is corresonponding building
    if Building.find_by(number: @building)
      @floors = Building.find_by(number: @building).floors.to_i #number of floors in the building
      #security will be ordered by id asceding.
      @securities = Security.where(building_number: @building)
    else
      redirect_to root_path
    end
  end

end
